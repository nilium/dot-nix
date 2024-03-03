require "digest/sha256"

XRANDR_CMD = {{ env("xrandr_bin") || "xrandr" }}

DATA = `#{XRANDR_CMD} --query --prop`
OUTPUT_PAT = %r[^(?<id>e?DP(?:-?\d+)+)\s+(?<state>(?:dis)?connected)\s+(?<suffix>[^(]*)]
PROP_PAT = %r[^\t(?<name>[^:]+):(?:$|\s*(?<rest>.+$))]

def sha256(data : String) : String
  digest = Digest::SHA256.new
  digest.update(data)
  output = digest.final
  Base64.encode(output).strip
end

class Output
  getter id : String
  getter edid_hash : String

  @connected : Bool
  @suffix : String
  
  def initialize(lines : Array(String))
    match = OUTPUT_PAT.match(lines[0])
    return nil if match.nil?
    @id = match["id"].to_s
    @connected = match["state"].to_s == "connected"
    @suffix = match["suffix"].to_s.strip
    @edid_hash = "-"

    edid_props = lines.chunk_while { |_, line| !PROP_PAT.matches? line }.select do |prop_lines|
      prop = PROP_PAT.match(prop_lines[0])
      prop && prop["name"] == "EDID"
    end.to_a

    if edid_props.empty?
      return
    end
    edid = edid_props[0]
    @edid_hash = sha256(edid[1..-1].map { |line| line.strip }.join(""))
  end

  def connected?
    @connected
  end

  def active?
    connected? && configured?
  end

  def configured?
    !@suffix.empty?
  end

  def to_s(io : IO)
    io << @id
    io << " " << (connected? ? "connected" : "disconnected")
    io << " " << @edid_hash
    io << " " << @suffix unless @suffix.empty?
  end
end

def xrandr_args(argv : Array(String), groups : Array(Output))
  by_name = {} of String => Output
  seen = Set(String).new
  groups.each do |group|
    by_name[group.edid_hash] = group if group.connected?
    by_name[group.id] = group
  end

  sets = ARGV.chunk_while { |b, a| a != "--output" }.to_a
  argv_else = [] of String
  sets = sets.flat_map do |args|
    next [] of String if args.size < 2 || args[0] != "--output"
    id = args[1]
    if id == "__else__"
      argv_else = args
      next [] of String
    end

    group = by_name[id]
    next [] of String if group.nil?

    seen.add group.id
    args[1] = group.id

    args
  end

  unless argv_else.empty?
    else_tail = argv_else[2..] || [] of String
    argv_else = groups.reject do |group|
      seen.includes? group.id
    end.flat_map do |group|
      ["--output", group.id, *else_tail]
    end.to_a
  end

  sets + argv_else
end

groups = DATA.lines.chunk_while do |_, line|
  !OUTPUT_PAT.matches? line
end.select do |lines|
  OUTPUT_PAT.matches? lines[0]
end.map do |lines|
  Output.new lines
end.to_a

cmd = ARGV.empty? ? "ls" : ARGV[0]

case cmd
when "ls"
  groups.each do |group|
    puts group
  end

when "active"
  groups.each do |group|
    puts group if group.active?
  end

when "connected"
  groups.each do |group|
    puts group if group.connected?
  end

when "disconnected"
  groups.each do |group|
    puts group unless group.connected?
  end

when "set"
  args = xrandr_args(ARGV[1..-1], groups)
  Process.exec(XRANDR_CMD, args)

else
  puts xrandr_args(ARGV, groups).join("\n")
end

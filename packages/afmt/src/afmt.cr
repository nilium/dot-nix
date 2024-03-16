# afmt: [fmt args...]
#
# Scan input for comment prefixes (e.g., //, ///, #, ##, ;, etc.) and pass
# that to fmt, along with additional arguments, as the formatting prefix.
# Currently only looks for -- (Lua, SQL, Ada), // (C++), # (Unix-y?),
# and ; (BASICs, Lisps) comments.


FMT_CMD = {{ env("fmt_bin") || "fmt" }}
COMMENT = %r[^\s*(?<prefix>--+|#|//+|;+)]

# Take default prefix from arguments.
prefix = ""
args = ARGV.reject do |arg|
  arg.starts_with?("-p").tap { |c| prefix = arg[2..-1] if c }
end

# Scan input for line comments without other text (looking for other
# sorts would be hard without something like treesitter and I'm lazy).
(input = STDIN.gets_to_end).lines.each do |line|
  next unless m = COMMENT.match(line)
  prefix = m["prefix"]
end

# Pass input through to fmt along with any detected comment prefix that
# differs from the default.

Process.run(FMT_CMD, ["-p#{prefix}", *args], input: Process::Redirect::Pipe, output: Process::Redirect::Inherit) do |proc|
  proc.input.write(input.to_slice)
  proc.input.close
end

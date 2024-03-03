function ep
    argparse \
        --name=ep        \
        --stop-nonopt    \
        --ignore-unknown \
        'p/print'        \
        '1/first'        \
        -- $argv

    if test (count $argv) -eq 1 -a "$argv[1]" = -
        cd -
        return $status
    end

    set printonly (test -n "$_flag_print"; echo $status)

    set fzfquery query
    if test -n "$_flag_first"
        set fzfquery filter
    end

    set candidates (
        set wnd 'right:57%'
        if test -n "$COLUMNS" -a "$COLUMNS" -lt 100
            set wnd 'up:75%'
        end

        parallel 2>/dev/null \
            --line-buffer \
            --quote       \
            --max-args 2  \
                fd \
                    $EP_FD_ARGS      \
                    --prune          \
                    --hidden         \
                    --no-ignore      \
                    --absolute-path  \
                    --max-depth {2}  \
                    --type directory \
                    --type file      \
                    $EP_FD_PATTERN   \
                    {1}              \
                ::: $EP_PATH |
            sed -Ee 's#^'{$HOME}'/#~/#;s#/[^/]+/?$##' |
            sort | uniq |
            fzf \
                --filepath-word                                  \
                --select-1                                       \
                --$fzfquery "$argv"
    )

    if not count $candidates &>/dev/null
        return 1
    end

    set sel $candidates[1]

    # Reformat selection back into a real path.
    if string match '~/*' $sel &>/dev/null
        set sel "$HOME/$(string sub --start 3 $sel)"
    end

    if ! test -d $sel
        echo "No selection" >&2
        return 1
    end

    if test $printonly -eq 0
        echo $sel
        return 0
    end

    cd $sel
end

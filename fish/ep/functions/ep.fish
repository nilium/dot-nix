function ep
    if test -z $EP_PARALLEL
        set EP_PARALLEL parallel
    end

    if test -z $EP_FD
        set EP_FD fd
    end

    if test -z $EP_FZF
        set EP_FZF fzf
    end

    if test -z $EP_SED
        set EP_SED sed
    end

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

        $EP_PARALLEL 2>/dev/null \
            --line-buffer \
            --quote       \
            --max-args 2  \
                $EP_FD \
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
            $EP_SED -Ee 's#^'{$HOME}'/#~/#;s#/[^/]+/?$##' |
            sort | uniq |
            $EP_FZF \
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

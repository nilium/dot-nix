set -g EP_PATH     \
    $HOME/src    4 \
    $HOME/p      4

set -g EP_FD_ARGS \
    -E gists        \
    -E vim          \
    -E vendor       \
    -E node_modules \
    -E venv         \
    -E mod          \
    -E zig-out      \
    -E zig-cache    \
    -E target       \
    -E bin          \
    -E '*.archive'

set -g EP_FD_PATTERN \
    '^(?:\.git|cpanfile|requirements\.txt|Gemfile|package\.json|go\.mod|[Cc]argo\.toml|build\.zig|rebar\.config)$|\.gemspec$'

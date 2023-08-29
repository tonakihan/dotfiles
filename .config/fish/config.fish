if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="$PATH:$HOME/.local/bin"
alias serve="browser-sync start --server --files ."

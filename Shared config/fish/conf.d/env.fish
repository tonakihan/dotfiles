if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $fish_user_path

if which helix &>/dev/null
    set -gx EDITOR helix
else if which hx &>/dev/null
    set -gx EDITOR hx
end

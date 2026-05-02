if status is-interactive
# Commands to run in interactive sessions can go here
end

if status is-interactive
    atuin init fish | source
    if command -q try
        try init ~/src/tries | source
    end
end

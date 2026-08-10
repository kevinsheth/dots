set -gx JAVA_HOME /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

if status is-interactive
    if command -q atuin
        atuin init fish | source
    end
    if command -q try
        try init fish ~/src/tries | source
    end
end

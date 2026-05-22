set -gx JAVA_HOME /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path /opt/homebrew/share/google-cloud-sdk/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

if status is-interactive
# Commands to run in interactive sessions can go here
end

if status is-interactive
    atuin init fish | source
    if command -q try
        try init fish ~/src/tries | source
    end
end

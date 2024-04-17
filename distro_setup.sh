#!/bin/bash

# List of packages to install
packages_common=(
    "python3"
    "python3-pip"
    "python3-neovim"
    "git"
    "curl"
    "unzip"
    "zsh"
)

packages_fedora=(
    "neovim"
    "btop"
    "nvtop"
)

packages_deb=(
    # Neovim build debian prerequisites
    # https://github.com/neovim/neovim/blob/master/BUILD.md#build-prerequisites
    "ninja-build" 
    "gettext"
    "cmake" 
    "build-essential"
)

flatpaks=(
    "org.gnome.Extensions"
    "com.github.tchx84.Flatseal"
    "io.github.peazip.PeaZip"
    "org.qbittorrent.qBittorrent"
    "com.github.johnfactotum.Foliate"
    "app.drey.Warp"
    "org.videolan.VLC"
    "com.github.unrud.VideoDownloader" 
    "com.opera.Opera"
    "org.telegram.desktop"
    "md.obsidian.Obsidian"
)

supported_distros=( "fedora" "debian" "ubuntu" )

# Determine the distribution
distro=$(. /etc/os-release && echo "$ID")

# Select packages and package manager accordingly to distributions
package_manager=""
suggest_restart=false
packages=()


# Check if a package is installed
is_installed() {
    local package=$1
    case "$distro" in
        "fedora")
            rpm -q "$package" &> /dev/null
            ;;
        "debian" | "ubuntu")
            dpkg -s "$package" &> /dev/null
            ;;
    esac
}


# Check if a package is available to install
is_available() {
    local package=$1
    case "$distro" in
        "fedora")
            dnf info "$package" &> /dev/null
            ;;
        "debian" | "ubuntu")
            apt-cache show "$package" &> /dev/null
            ;;
    esac
}


# Check if a flatpak package is installed
is_flatpak_installed() {
    local package=$1
    flatpak list --app --columns=application | grep -q "^$package$" &> /dev/null
}


# Check if a flatpak package is available
is_flatpak_available() {
    local package=$1
    flatpak remote-info --cached flathub "$package" &> /dev/null
}


# Function to populate the .zshrc file
zshrc_config() {
    local zshrc_path="$HOME/.zshrc"
    local zshrc_content=$(cat <<- 'EOF'

# Set vim keybindings
bindkey -v

# Do not keep history duplicates
setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias cperf='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias vperf='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'
EOF
)
    echo "$zshrc_content" > "$zshrc_path"
}


zplug_config() {
    local zshrc_path="$HOME/.zshrc"
    local zplug_content=$(cat <<- 'EOF'
source ~/.zplug/init.zsh
#zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/sudo", from:oh-my-zsh
#zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "romkatv/powerlevel10k, as:theme, depth:1"
#zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf"
#zplug "themes/robbyrussell", from:oh-my-zsh, as:theme   # Theme

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check; then
	printf "Install? [y/N]: "
	if read -q; then
	    echo; zplug install
	fi
fi
zplug load
EOF
)
    echo "$zplug_content" >> "$zshrc_path"
}


install_packages() {
    # Check if there was already pending a system restart
    case "$distro" in
        "fedora")
            ! sudo dnf needs-restarting -r &> /dev/null
            ;;
        "debian" | "ubuntu")
            [ -f /var/run/reboot-required ] || [ -d /var/run/reboot-required.d ]
            ;;
    esac
    if [[ "$?" -eq 0 ]]; then
        echo "Your system has pending updates, please restart your system before running the script."
        echo "Exiting..."
        exit 1
    fi

    echo "-------------------------------------------------------"
    echo "Updating/installing system packages..."
    echo "-------------------------------------------------------"

    case "$distro" in
    "fedora")
        #sudo dnf update -y #> /dev/null
        sudo dnf makecache -y
        package_manager="dnf"
        packages=("${packages_common[@]}" "${packages_fedora[@]}")
        ;;
    "debian" | "ubuntu")
        sudo apt update -y
        #sudo apt upgrade -y #> /dev/null
        package_manager="apt"
        packages=("${packages_common[@]}" "${packages_deb[@]}")
        ;;
    esac

    local to_install=()
    for package in "${packages[@]}"; do
        if ! is_installed "$package" && is_available "$package"; then
            to_install+=("$package")
        elif ! is_available "$package"; then
            echo "The package $package is not available in the remote repository. Skipping."
        else
            echo "The package $package was already installed. Skipping."
        fi
    done
    
    if [[ "${#to_install[@]}" -gt 0 ]]; then
        read -p "The following packages will be installed: ${to_install[*]}. Proceed? (y/N) " choice
        case "$choice" in
            y|Y)
                sudo $package_manager install -y "${to_install[@]}" #> /dev/null
                suggest_restart=true
                ;;
            *)
                echo "Skipping packages installations."
                ;;
        esac
    fi
}


customize_terminal(){
    echo "-------------------------------------------------------"
    echo "Adding Caskaydia Nerd Font to system fonts..."
    echo "-------------------------------------------------------"

    if ! is_installed "curl" && ! is_installed "unzip"; then
        echo "Operation failed, make sure you have curl and unzip installed and re-run the script again."
        echo "Exiting..."
        exit 1
    fi

    font_name="CascadiaMono"
    fonts_dir="/usr/share/fonts"
    font_path="$fonts_dir/$font_name"

    if [ -d $font_path ]; then
        echo "Directory $font_path already existed. Skipping."
    else
        # Download the latest Caskaydia Nerd Font
        curl -L -s -o ~/$font_name.zip $(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*$font_name.zip" | cut -d '"' -f 4)
        sudo unzip ~/$font_name.zip '*.ttf' -d "$font_path" > /dev/null
        rm ~/$font_name.zip
        # Update the font cache
        sudo fc-cache -f -v > /dev/null
    fi

    if ! is_installed "zsh"; then
        echo "Operation failed, make sure you have zsh installed and re-run the script again."
        echo "Exiting..."
        exit 1
    fi

    echo "-------------------------------------------------------"
    echo "Configuring .zshrc..."
    
    if [ -s ~/.zshrc ]; then
        read -p "The file ~/.zhsrc already existed and had a configuration, would you like to replace it?: ${to_install[*]}. Proceed? (y/N) " choice
        case "$choice" in
            y|Y)
                # It already replaces the existing one
                zshrc_config
                ;;
            *)
                echo "Skipping."
                ;;
        esac
    else
        zshrc_config
    fi

    echo "-------------------------------------------------------"
    echo "Configuring zplug..."

    if [ -d ~/.zplug ]; then
        read -p "The directory ~/.zplug already existed, would you like to replace it?: ${to_install[*]}. Proceed? (y/N) " choice
        case "$choice" in
            y|Y)
                rm -rf ~/.zplug
                curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
                ;;
            *)
                echo "Skipping."
                ;;
        esac
    fi
    
    if grep -q "source ~/.zplug/init.zsh" ~/.zshrc; then
        echo "Zplug was already sourced in ~/.zshrc. Please verify manually. Skipping."
    else
        zplug_config
    fi

    echo "-------------------------------------------------------"
    echo "Setting shell to zsh..."
    
    if [ -n "$SHELL" ] && [ "$SHELL" = "/usr/bin/zsh" ]; then
        echo "Zsh was already set as the default shell. Skipping."
    else
        chsh -s $(which zsh)
        suggest_restart=true
    fi

}


install_flatpak_packages() {
    echo "-------------------------------------------------------"
    echo "Installing flatpak packages..."
    echo "-------------------------------------------------------"

    if ! is_installed "flatpak"; then
        echo "operation failed, make sure you have flatpak installed and re-run the script again."
        echo "exiting..."
        exit 1
    fi

    local to_install=()
    for package in "${flatpaks[@]}"; do
	    if ! is_flatpak_installed "$package" && is_flatpak_available "$package"; then
		    to_install+=("$package")
	    elif ! is_flatpak_available "$package"; then
		    echo "Flatpak package $package is not available in the remote repository. Skipping."
	    else
		    echo "Flatpak package $package was already installed. Skipping."
	    fi
    done

    if [[ "${#to_install[@]}" -gt 0 ]]; then
        read -p "The following Flatpak packages will be installed: ${to_install[*]}. Proceed? (y/N) " choice
        case "$choice" in
            y|Y)
                flatpak install -y --noninteractive flathub "${to_install[@]}"
                ;;
            *)
                echo "Skipping Flatpak packages installations."
                ;;
        esac
    fi
}


fedora_system_setup(){
    echo "-------------------------------------------------------"
    echo "Fedora system setup..."
    echo "-------------------------------------------------------"
    
    if [[ "$distro" != "fedora" ]]; then
        echo "Current distribution is not Fedora"
        echo "Exiting..."
        exit 1
    fi

    echo "-------------------------------------------------------"
    echo "Configuring dnf..."
    # Check if the values are already present
    if grep -q "^max_parallel_downloads=10$" /etc/dnf/dnf.conf && grep -q "^fastestmirror=True$" /etc/dnf/dnf.conf; then
        echo "The values were already present in /etc/dnf/dnf.conf"
    else
        echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
        suggest_restart=true
    fi

    echo "-------------------------------------------------------"
    echo "Setting governor mode to performance..."
    
    local script_name="change_governor.sh"
    local script_dir="$HOME/.startup_scripts"
    local script_path="$script_dir/$script_name"
    local script_content=$(cat <<- 'EOF'
#!/usr/bin/bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
EOF
)

    local service_name="change_governor.service"
    local service_dir="/etc/systemd/system"
    local service_path="$service_dir/$service_name"
    local service_content=$(envsubst <<- 'EOF'
[Unit]
Description=Change governor to performance

[Service]
ExecStart=/usr/bin/bash $script_path
User=root
Group=root
Type=simple
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF
)

    if [ -f "$script_path" ]; then
        echo "$script_name already existed in $script_dir. Skipping."
    else
        mkdir "$script_dir" && touch "$script_path"
        echo "$script_content" > "$script_path"
        sudo chmod +x "$script_path"
    fi

    if [ -f "$service_path" ]; then
        echo "$service_name already existed in $service_dir. Skipping."
        echo "Further service actions require manual attention." 
        echo "You are advised to check manually the service status with:"
        echo "sudo systemctl status $service_name"
    else
        sudo touch "$service_path"
        echo "$service_content" | sudo tee "$service_path" > /dev/null
        sudo chmod +x "$service_path"

        sudo systemctl daemon-reload > /dev/null
        sudo systemctl enable "$service_name" > /dev/null
        sudo systemctl start "$service_name" > /dev/null
        suggest_restart=true
    fi

}

main(){
    check_supported_distros(){
        for supported_distro in "${supported_distros[@]}"; do
            if [[ "$distro" == "$supported_distro" ]]; then
                return 0  # Supported distribution found
            fi
        done

        echo "The current Linux distribution is not supported."
        echo "This script is only intended for running on Fedora, Debian and Ubuntu."
        echo "Exiting..."
        exit 1
    }
    # Do not run script if distro is not supported.
    check_supported_distros

    while true; do
        clear
        echo "==================================================================="
        echo "Options"
        echo "-------------------------------------------------------------------"
        echo "1- System setup"
        echo "  . update system package manager cache"
        echo "  . install required packages"
        echo "  . download CaskaydiaMono Nerd Font (manual setup required) (*)"
        echo "  . create a default .zshrc (*)"
        echo "  . install zplug and add zplug config to .zhsrc (*)" 
        echo "  . set zsh as default user shell (*)"
        echo "-------------------------------------------------------------------"
        echo "2- Install flatpak packages"
        echo "-------------------------------------------------------------------"
        echo "3- Fedora setup"
        echo "  . configure dnf for faster downloads (*)"
        echo "  . create startup service for setting the governor to performance (*)"
        echo "-------------------------------------------------------------------"
        echo "q- Quit"
        echo "==================================================================="
        echo "(*) - if not exists/set/configured"

        read -p "Enter the option/s you would like to perform (1, 2, 3 or q): " selection
        case "$selection" in
            1)
                clear
                install_packages
                customize_terminal
                ;;
            2)
                clear
                install_flatpak_packages
                ;;
            3)
                clear
                fedora_system_setup
                ;;
            q)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
        
        echo "-------------------------------------------------------"
        if "$suggest_restart"; then
            echo "Some changes need a system restart to take effect."
            echo "Please restart your system to finish."
            echo "Exiting..."
            exit 0
        else
            echo "Finished!"
        fi
        echo "-------------------------------------------------------"
    
        read -p "Press Enter to continue..."
    done
}

main

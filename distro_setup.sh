#!/bin/bash

MARKER='\e[31m'
EMARKER='\e[0m'

common_packages=(
    "python3"
    "python3-pip"
    "git"
    "curl"
    "unzip"
    "zsh"
)

fedora_packages=(
    #"python3-neovim"
    "gnome-shell-extension-dash-to-dock"
    "gnome-shell-extension-appindicator"
    "gnome-tweaks"
    "btop"
    "nvtop"
)

deb_packages=(
)

flatpak_packages=(
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

# Determine the distribution
distro=$(. /etc/os-release && echo "$ID")

# Select packages and package manager accordingly to distributions
suggest_restart=false


check_supported_distros(){
    # The script is only supposed to run for distros available in supported_distros
    supported_distros=("fedora" "debian" "ubuntu")
    found_distro=false
    for supported_distro in "${supported_distros[@]}"; do
        if [[ "$distro" == "$supported_distro" ]]; then
            found_distro=true
            break
        fi
    done

    if ! "$found_distro"; then
        echo "The current Linux distribution is not supported."
        echo "This script is only intended for running on ${supported_distros[@]}."
        echo "Exiting..."
        exit 1
    fi
}


check_pending_restart(){
    case "$distro" in
    "fedora")
        ! sudo dnf needs-restarting -r &> /dev/null
        ;;
    "debian" | "ubuntu")
        [ -f /var/run/reboot-required ] || [ -d /var/run/reboot-required.d ]
        ;;
    esac
    if [[ "$?" -eq 0 ]]; then
        echo "Your system has pending updates, please restart it and re-run the script."
        echo "Exiting..."
        exit 1
    fi
}


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
	printf "Zplug will install the plugins sourced in .zshrc. Proceed? [y/N]: "
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
    # First argument to control whether to echo "Skipping" or not
    local echo_log="$1"
    local packages=("${@:2}")

    local package_manager=""
    case "$distro" in
    "fedora")
        sudo dnf makecache -y
        package_manager="dnf"
        ;;
    "debian" | "ubuntu")
        sudo apt update -y
        package_manager="apt"
        ;;
    esac

    local to_install=()
    for package in "${packages[@]}"; do
        if ! is_installed "$package" && is_available "$package"; then
            to_install+=("$package")
        elif ! is_available "$package"; then
            echo "The package $package is not available in the remote repository."
            echo "Manual checking will be required."
            echo "Exiting..."
            exit 1
        else
            if "$echo_log"; then
                echo "System package $package was already installed. Skipping."
            fi
        fi
    done
    
    if [[ "${#to_install[@]}" -gt 0 ]]; then
        check_pending_restart
        read -p "The following packages will be installed: ${to_install[*]}. Proceed? (y/N) " choice
        case "$choice" in
            y|Y)
                sudo $package_manager install -y "${to_install[@]}" #> /dev/null
                ;;
            *)
                echo "Packages installations aborted."
                echo "Either perform a manual check or re-run the script and accept to install the required packages."
                echo "Exiting..."
                exit 1
                ;;
        esac
    fi
}


install_system_packages() {
    # List of packages to install
    local packages=()

    echo
    echo "Installing distro packages..."

    case "$distro" in
    "fedora")
        packages=("${common_packages[@]}" "${fedora_packages[@]}")
        ;;
    "debian" | "ubuntu")
        packages=("${common_packages[@]}" "${deb_packages[@]}")
        ;;
    esac
    
    install_packages "true" "${packages[@]}"
}


setup_terminal(){
    echo
    echo "Setting up terminal."
    
    local dependencies=("zsh" "curl" "unzip")
    install_packages "false" "${dependencies[@]}"

    echo
    echo "Configuring zsh..."

    if [ -s ~/.zshrc ]; then
        read -p "The file ~/.zhsrc already existed and isn't empty, would you like to replace it? (y/N)" choice
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

    echo
    echo "Configuring zplug..."

    if [ -d ~/.zplug ]; then
        read -p "The directory ~/.zplug already existed, would you like to replace it? (y/N) " choice
        case "$choice" in
            y|Y)
                rm -rf ~/.zplug
                curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
                ;;
            *)
                echo "Skipping."
                ;;
        esac
    else
	    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    fi
    
    if grep -q "source ~/.zplug/init.zsh" ~/.zshrc; then
        echo -e "${MARKER}Zplug was already sourced in ~/.zshrc. Verify manually the .zshrc file for missing pluggins.${EMARKER}"
    else
        zplug_config
    fi


    echo
    echo "Adding Caskaydia Nerd Font to system fonts..."
    
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

    echo
    echo "Setting shell to zsh..."
    
    if [ -n "$SHELL" ] && [ "$SHELL" = "/usr/bin/zsh" ]; then
        echo "Zsh was already set as the default shell. Skipping."
    else
        chsh -s $(which zsh)
        suggest_restart=true
    fi
}


setup_neovim(){
    echo
    echo "Neovim setup..."

    if is_installed "neovim"; then
        echo "Neovim was already installed. Skipping."
    else
        local packages=()
        case "$distro" in
        "fedora")
            packages=("git" "neovim")
            install_packages "false" "${packages[@]}"
            ;;
        "debian" | "ubuntu")
            packages=(
                "git"
                "file"
                "ninja-build"
                "gettext"
                "cmake"
                "unzip"
                "curl"
                "build-essential"
            )
            install_packages "false" "${packages[@]}"

            cd ~/ && git clone https://github.com/neovim/neovim
            cd neovim && git checkout stable
            make CMAKE_BUILD_TYPE=Release
            cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
            cd ~/ && rm -rf neovim
            
            # Should be done after the manual build to avoid an old nvim installation.
            #packages=("python3-neovim")
            #install_packages "false" "${packages[@]}"
            ;;
        esac
    fi

    local kickstart_path="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

    if [ -d "$kickstart_path" ]; then
        echo -e "The directory $kickstart_path already existed. Skipping."
        echo "${MARKER}Manual checking will be required.${EMARKER}"
        return 0
    fi

    # Kickstart nvim
    git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
}


setup_git(){
    echo
    echo "Git setup..."

    local dependencies=("git")
    install_packages "false" "${dependencies[@]}"

    # Check if user.name is configured
    if [ -z "$(git config --get user.name)" ]; then
        read -p "Enter username: " username
        git config --global user.name "$username"
    else
        echo "User name is already configured."
    fi

    # Check if user.email is configured
    if [ -z "$(git config --get user.email)" ]; then
        read -p "Enter email: " email
        git config --global user.email "$email"
    else
        echo "User email is already configured."
    fi

    if [ -d ~/.ssh ] && [ -n "$(ls -A ~/.ssh)" ]; then
        echo "The directory ~/.ssh already existed and is not empty."
        echo "Manual checking will be required."
        echo "Exiting..."
        exit 1
    fi

    echo "Press enter for accepting the default key location."
    ssh-keygen -t ed25519 -C "$email"
    
    eval "$(ssh-agent -s)"
    
    ssh-add ~/.ssh/id_ed25519

    echo -e "${MARKER}Select and copy the generated ssh key (whole line)\ndisplayed below to your clipboard.${EMARKER}"
    
    echo
    cat ~/.ssh/id_ed25519.pub
    echo

    echo -e "${MARKER}Manual add it to your github account, go to:${EMARKER}"
    echo "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
    echo "and follow from step 2."
}


install_flatpak_packages() {
    echo
    echo "Installing flatpak packages..."

    # Fedora has installed flatpak by default
    if ! is_installed "flatpak"; then
        local dependencies=("flatpak" "gnome-software-plugin-flatpak")
        install_packages "false" "${dependencies[@]}"
        echo "Flatpak was installed, a restart will be required before installing flatpak packages."
        echo "Restart your system an re-run this script option."
        echo "Exiting..."
        exit 1
    fi

    # Make sure the remote repo is always added
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    local to_install=()
    for package in "${flatpak_packages[@]}"; do
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
                echo "Skipping."
                ;;
        esac
    fi
}


set_faster_downloads_dnf(){
    echo
    echo "Configuring dnf..."

    # Check if the values are already present
    if grep -q "^max_parallel_downloads=10$" /etc/dnf/dnf.conf && grep -q "^fastestmirror=True$" /etc/dnf/dnf.conf; then
        echo "The values were already present in /etc/dnf/dnf.conf"
    else
        echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
        suggest_restart=true
    fi
}

set_governor_to_performance(){
    echo
    echo "Setting governor mode to performance..."
    
    # Check if the governor is already in performance mode and skip 
    # the service creation
    governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null) 

    if [ "$governor" = "performance" ]; then
        echo "The CPU scaling governor was already set to 'performance'."
        echo "There is no need to create a startup service for it. Skipping."
        return 0
    fi
    
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
    local service_content=$(envsubst <<- EOF
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
        echo -e "${MARKER}Manual checking will be required.${EMARKER}"
        echo -e "You are advised to run:\nsudo systemctl status $service_name"
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


setup_fedora(){
    echo
    echo "Fedora system setup..."
    
    if [[ "$distro" != "fedora" ]]; then
        echo "Current distribution is not Fedora."
        echo "Exiting..."
        return 0
    fi
    
    set_faster_downloads_dnf
    set_governor_to_performance
}


main(){
    check_supported_distros

    while true; do
        clear
        echo "==================================================================="
        echo "Options"
        echo "-------------------------------------------------------------------"
        echo "1- Install system packages"
        echo "-------------------------------------------------------------------"
        echo "2- Setup terminal"
        echo "  . download CaskaydiaMono Nerd Font (manual setup required) (*)"
        echo "  . create a default .zshrc (*)"
        echo "  . install zplug and add zplug config to .zhsrc (*)" 
        echo "  . set zsh as default user shell (*)"
        echo "-------------------------------------------------------------------"
        echo "3- Setup neovim"
        echo "  . install neovim (*)"
        echo "  . download and set kickstart nvim (*)"
        echo "-------------------------------------------------------------------"
        echo "4- Setup git"
        echo "  . install git (*)"
        echo "  . set global user and name (*)"
        echo "  . generate a ssh key (further manual actions are required on github) (*)"
        echo "-------------------------------------------------------------------"
        echo "5- Install flatpak packages"
        echo "-------------------------------------------------------------------"
        echo "6- Full system setup"
        echo "  . options included (1,2,3,4,5)"
        echo "-------------------------------------------------------------------"
        echo "7- Fedora setup"
        echo "  . configure dnf for faster downloads (*)"
        echo "  . create startup service for setting the governor to performance (*)"
        echo "-------------------------------------------------------------------"
        echo "q- Quit"
        echo "==================================================================="
        echo "(*) - if not exists/set/configured"

        read -p "Enter the option/s you would like to perform (1, 2, 3, 4, 5, 6, 7 or q): " selection
        case "$selection" in
            1)
                clear
                install_system_packages
                ;;
            2)
                clear
                setup_terminal
                ;;
            3)
                clear
                setup_neovim
                ;;
            4)
                clear
                setup_git
                ;;
            5)
                clear
                install_flatpak_packages
                ;;
            6)
                clear
                install_system_packages
                setup_terminal
                setup_neovim
                install_flatpak_packages
                setup_git
                ;;
            7)
                clear
                setup_fedora
                ;;
            
            q)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
        
        echo
        if "$suggest_restart"; then
            echo "Some changes need a system restart to take effect."
            echo "Please restart your system to finish."
            echo "Exiting..."
            exit 0
        else
            echo "Finished!"
        fi
        read -p "Press Enter to continue..."
    done
}

main

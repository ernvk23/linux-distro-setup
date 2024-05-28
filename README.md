# Linux distro setup

This script automates the setup process after a fresh installation of Fedoara, Debian and Ubuntu Linux distributions. It installs essential packages, configures the terminal, development tools, and various desktop applications.

## Installation

### Prerequisites
- `curl` (should be pre-installed on most Linux distributions)

### Download
1. Open your terminal and navigate to the desired directory.
2. Run the following command to download the script:
  ```bash
  curl -O https://raw.githubusercontent.com/ernvk23/linux-distro-setup/main/distro_setup
  ```
### Usage
1. Review the script and modify the package lists as needed.
2. Run the following command to make the script executable and run it:
  ```bash
  chmod +x ./distro_setup && ./distro_setup
  ```

#### Detailed description of what it does/installs.
1. Common packages
    - python3, python3-pip, pip, git, curl, unzip
2. Fedora Packages
    - Dash to Dock, AppIndicator, Tweaks, Pomodoro, Caffeine, btop, nvtop
3. Desktop Tools
    - Terminal configuration (zsh, syntax highlighting, autosuggestions, history search, powerlevel10k theme)
    - Neovim with kickstart.nvim
    - Git with SSH key generation for github setup
3. Flatpak Apps
    - Extensions, Flatseal, PeaZip, qBittorrent, Foliate, Warp, VLC, Video Downloader, Opera,  Telegram, Obsidian, Blanket
5. Fedora dnf optimization, performance tuning, yaru icon theme

#### Extract from the script's menu
```bash
echo "Options"
echo "-------------------------------------------------------------------"
echo "1- System setup"
echo "-------------------------------------------------------------------"
echo "  . install required dependencies"
echo "  . download CaskaydiaMono Nerd Font (manual setup required) (*)"
echo "  . create a default .zshrc (*)"
echo "  . install zplug and add zplug config to .zhsrc (*)" 
echo "  . set zsh as default user shell (*)"
echo "  . install neovim (*)"
echo "  . download and set kickstart nvim (*)"
echo "  . install git (*)"
echo "  . set git lobal user and name (*)"
echo "  . generate a ssh key (further manual actions are required on github) (*)"
echo "-------------------------------------------------------------------"
echo "2- Install flatpak packages (*)"
echo "-------------------------------------------------------------------"
echo "3- Full system setup (option 1 and 2)"
echo "-------------------------------------------------------------------"
echo "------------------------ FEDORA ONLY ------------------------------"
echo "-------------------------------------------------------------------"
echo "4- Configure dnf for faster downloads (*)"
echo "-------------------------------------------------------------------"
echo "5- Permanent set the governor mode to performance (*)"
echo "-------------------------------------------------------------------"
echo "6- Set yaru icon theme (*)"
echo "-------------------------------------------------------------------"
echo "q- Quit"
echo "==================================================================="
echo "(*) - if not exists/set/configured"
```

### Tested Distributions
- Fedora 40 *Workstation* **(GNOME)**
- Debian 12 *Bookworm* **(GNOME)**
- Ubuntu 24.04 *Noble Numbat* **(GNOME)**

***Note***: This script is designed to run only on the listed `Fedora, Debian, and Ubuntu` distributions using the `GNOME` desktop environment. It includes a check to prevent execution on other platforms, but you can modify the script to suit your specific needs.

### Motivation
This script was born out of a bit of ADHD and the desire to periodically clean install the Linux distro I'll be using for a while, as well as for migrating to a new stable major release. I use it mainly with Fedora (daily driver) and Debian (WSL2). Somehow, I used to enjoy the painful yet oddly enjoyable process of setting everything up each time, but I eventually got tired of it, and this script now aims to automate all those repetitive tasks.

### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

### License
This project is licensed under the [MIT License](LICENSE.md).

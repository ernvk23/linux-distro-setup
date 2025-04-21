# Linux distro setup

This script automates the setup process after a fresh installation of Fedora, Debian and Ubuntu Linux distributions. It installs essential packages, configures the terminal, development tools, and various desktop applications.

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
    - Dash to Dock, AppIndicator, Tweaks, Pomodoro, Caffeine, btop, nvtop, powertop
3. Desktop Tools
    - Terminal configuration (zsh, syntax highlighting, autosuggestions, history search, powerlevel10k theme)
    - Neovim with kickstart.nvim
    - Git with SSH key generation for github setup
3. Flatpak Apps
    - Extension Manager, Flatseal, PeaZip, qBittorrent, Foliate, Warp, VLC, Video Downloader, Opera, Obsidian, Blanket
5. Others (Fedora)
    - add h.264 support for HW acceleration
    - enable HW acceleration on Firefox
    - allow faster dnf downloads
    - set permanently governor's mode to performance
    - change yaru icons theme color
    - disable PPD color change
    - setup local network share using samba
    - install cloudflare warp (VPN like)

#### Script's code snippet (shown menu)
```bash
echo "--------------------------- Setup Options ---------------------------"
echo "1- Minimal system setup"
echo "   • Install optional packages"
echo "   • Set up Zsh with plugins (syntax highlighting, autosuggestions, etc.)"
echo "   • Install Caskaydia Nerd Font"
echo "   • Install and configure Neovim with kickstart"
echo "   • Set up Git (install, configure, generate SSH key)"
echo "2- Install Flatpak packages"
echo "3- Full system setup (includes options 1 and 2)"
echo "-------------------------- Fedora Options --------------------------"
echo "4- Enable system's and Firefox hardware acceleration support"
echo "   • Install non-free media codecs (h.264, etc.)"
echo "   • Enable system-wide and Firefox's hardware acceleration support"
echo "5- Disable GNOME power-profile-daemon color change (AMD-based; proceed if you know what you are doing!)"
echo "6- Set Yaru icon theme"
echo "7- Configure DNF for faster downloads (Not recommended; proceed if you know what you are doing!)"
echo "8- Set governor mode to performance permanently (Not recommended; proceed if you know what you are doing!)"
echo -e "9- Setup a local network share with samba ($HOME/Shared by default)"
echo "----------------------- Fedora Unstable Options --------------------"
echo "10- Install Cloudflare WARP (VPN-like service)"
echo "q- Quit"
echo "--------------------------------------------------------------------"
echo "Note: All options will only be applied if not already set/configured."
```

### Tested Distributions
- Fedora 42 *Workstation* **(GNOME)**
- Debian 12 *Bookworm* **(GNOME)**
- Ubuntu 24.04 *Noble Numbat* **(GNOME)**

***Note***: This script is designed to run only on the listed `Fedora, Debian, and Ubuntu` distributions using the `GNOME` desktop environment. It includes a check to prevent execution on other platforms, but you can modify the script to suit your specific needs.

### Motivation
This script was born out of a bit of ADHD and the desire to periodically clean install the Linux distro I'll be using for a while, as well as for migrating to a new stable major release. I use it mainly with Fedora (daily driver) and Debian (WSL2). Somehow, I used to enjoy the painful yet oddly enjoyable process of setting everything up each time, but I eventually got tired of it, and this script now aims to automate all those repetitive tasks.

### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

### License
This project is licensed under the [MIT License](LICENSE.md).

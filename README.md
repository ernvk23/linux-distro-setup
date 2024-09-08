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
    - install cloudflare warp (VPN like) (WARNING!!! breaks gnome camera)

#### Script's code snippet (shown menu)
```bash
echo "--------------------------- Options -------------------------------"
echo "-------------------------------------------------------------------"
echo "1- Minimal system setup"
echo "  . install distro packages"
echo "  . add Caskaydia Nerd Font to system's fonts (manual setup required) (*)"
echo "  . create a default zsh configuration file (*)"
echo "  . install zplug as zsh pluggin manager (*)" 
echo "  . set zsh as the default user shell (*)"
echo "  . install neovim set it up with kickstart nvim (*)"
echo "-------------------------------------------------------------------"
echo "2- Install flatpak packages (*)"
echo "-------------------------------------------------------------------"
echo "3- Git setup"
echo "  . install git (*)"
echo "  . set git global user and name (*)"
echo "  . generate a ssh key (further manual actions are required on github) (*)"
echo "-------------------------------------------------------------------"
echo "4- Full system setup (options included: 1,2,3)"
echo "-------------------------------------------------------------------"
echo "---------------------------- Fedora -------------------------------"
echo "5- Install additional non-free media codecs to enable h.264 support (*)"
echo "6- Enable Firefox's hardware acceleration support (*)"
echo "7- Configure systems's dnf for faster downloads (*)"
echo "8- Permanent set the governor mode to performance (*)"
echo "9- Set yaru icon theme (*)"
echo "10- Disable gnome power-profile-daemon (PPD) color change (AMD-based) (*)"
echo "-------------------------------------------------------------------"
echo "------------------ Fedora (unstable features) ---------------------"
echo "11- Install cloudflare warp (VPN like) (*)"
echo -e "  . WARNING: When installed, there seems to be an issue that prevents starting gnome's camera (snapshot)\n  without manually restarting the PipeWire service. However, the system's camera will remain\n  available and usable, just not through the snapshot feature. It is also possible to experience\n  further issues with PipeWire. CAUTION IS ADVISED."
echo "q- Quit"
echo "-------------------------------------------------------------------"
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

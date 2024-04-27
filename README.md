# Linux distro setup

This script automates the setup process after a fresh installation of Fedoara, Debian and Ubuntu Linux distributions. It installs essential packages, configures the terminal, development tools, and various desktop applications.

## Installation

### Prerequisites
- `curl` (should be pre-installed on most Linux distributions)

### Download
1. Open your terminal and navigate to the desired directory.
2. Run the following command to download the script:
```bash
curl -O https://raw.githubusercontent.com/ernvk23/linux-distro-setup/main/distro_setup.sh
```
3. Make the script executable:
```bash
chmod +x ./distro_setup.sh
```
### Usage
Rewiew the script and modify the package lists as neeede, then run:
```bash
./distro_setup.sh
```

#### Packages
1. Common Packages
  - python3, pip, git, curl, unzip, zsh
2. Desktop Tools
  - Terminal configuration (zsh, syntax highlighting, autosuggestions, history search, powerlevel10k theme)
  - Neovim with kickstart.nvim
  - Git with SSH key generation for github setup
3. Flatpak Apps
  - Extensions, Flatseal, PeaZip, qBittorrent, Foliate, Warp, VLC, Video Downloader, Opera,  Telegram, Obsidian
4. Fedora Packages
  - Dash to Dock, AppIndicator, GNOME Tweaks, btop, nvtop
5. Fedora dnf optimization and performance tuning

### Tested Distributions
  - Fedora Workstation 40
  - Debian 12 "Bookworm"
  - Ubuntu 24.04 LTS

### Motivation
This script was born out of a bit of ADHD and the desire to periodically clean install the Linux distro I'll be using for a while, as well as for migrating to a new stable major release. I use it mainly with Fedora (daily driver) and Debian (WSL2). Somehow, I used to enjoy the painful yet oddly enjoyable process of setting everything up each time, but I eventually got tired of it, and this script now aims to automate all those repetitive tasks.

### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

### License
This project is licensed under the [MIT License](LICENSE.md).

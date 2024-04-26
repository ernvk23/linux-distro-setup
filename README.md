# Linux Distro Setup

This repository contains a script that automates the setup process after a fresh installation of `Debian | Ubuntu | Fedora` Linux distributions. It can:
1. install essential system packages.
2. configure the terminal with zsh, syntax highlighting, autosuggestions and history substring search.
3. setup neovim and configure it with kickstart.nvim.
4. setup git and generate a ssh key needed for further github setup.
5. install flatpak packages.
6. setup fedora dnf for faster downloads and set permanent governor mode to performance.

## Motivation
This script was born out of a bit of ADHD and the desire to periodically clean install the Linux distro I'll be using for a while, as well as for migrating to a new stable major release. I use it mainly with Fedora (daily driver) and Debian (WSL2). Somehow, I used to enjoy the painful yet oddly enjoyable process of setting everything up each time, but I eventually got tired of it, and this script now aims to automate all those repetitive tasks.

## Usage
### Tested on the following distros:
- Debian 12 "Bookworm"
- Ubuntu 24.04 LTS
- Fedora 40

### Prerequisites
- `curl` (should be pre-installed on most Linux distributions)

### Installation

1. Open your terminal and navigate to the desired directory.
2. Run the following command to download the `distro_setup.sh` script:
```bash
curl -O https://raw.githubusercontent.com/ernvk23/linux-distro-setup/main/distro_setup.sh
```
3. (Optional) You're advised to manually check the packages that will be installed and remove/modify/add the ones you'll want before running the script.
4. Make the script executable and run it:
```bash
chmod +x ./distro_setup.sh && ./distro_setup.sh
```

##### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

##### License
This project is licensed under the [MIT License](LICENSE.md).

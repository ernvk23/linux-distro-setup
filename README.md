# Linux Distro Setup

This repository contains a script that automates the setup process for a fresh installation of either `Debian, Ubuntu or Fedora` Linux distributions. It can:
1. install essential system packages.
2. configure the terminal with zsh, syntax highlighting, autosuggestions and history substring search.
3. setup neovim and configure it with kickstart.nvim.
4. setup git and generate a ssh key needed for further github setup.
5. install flatpak packages.
6. setup fedora dnf for faster downloads and set permanent governor mode to performance.

## Motivation
This script was created due to a tendency for wanting to perform fresh installs of Fedora after each major OS release, and even sometimes simply for the sake of maintaining a clean system (a somewhat painful but oddly enjoyable process). It aims to streamline the repetitive setup tasks that typically follow a fresh installation, saving time and effort.

## Usage

### Prerequisites
- `curl` (should be pre-installed on most Linux distributions)

### Installation

1. Open your terminal and navigate to the desired directory.
2. Run the following command to download the `distro_setup.sh` script:

```bash
curl -O https://raw.githubusercontent.com/ernvk23/linux-distro-setup/main/distro_setup.sh
```
3. Make the script executable and run it:
```bash
chmod +x ./distro_setup.sh && ./distro_setup.sh
```

##### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

##### License
This project is licensed under the [MIT License](LICENSE.md).

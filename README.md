# Linux Distro Setup

This repository contains a script that automates the setup process for a fresh installation of Debian/Ubuntu and Fedora Linux distributions. It installs essential system packages, configures the terminal, sets up Neovim, Git, and installs Flatpak packages.

## Motivation
This script is the result of a bit of ADHD and wanting to fresh install Fedora after each major OS version, and then needing to go trough the same process time after time, so this should prevent all that repetitive setup afterwards.

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

##### Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

##### License
This project is licensed under the MIT License.
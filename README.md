
## If you are a bit like me enjoy!

# Usage instructions
### Prerequisites
    - curl
### Installation (reproduce steps)
1. cd ~/ && curl -O https://raw.githubusercontent.com/ernvk23/linux-distro-setup/main/distro_setup.sh
#### Never run scripts on your system before been fully aware of what it does, if you don't trust me (and you shoudn't
#### just go trough it and verify the stuff it does before executing the next instruction."
2. chmod +x ./distro_setup.sh && ./distro_setup.sh


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
3. Make the script executable:
```bash
chmod +x ./distro_setup.sh
```
4. Run the script:
```bash
./distro_setup.sh
```

##### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

##### Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

##### License
This project is licensed under the MIT License.
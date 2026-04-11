#!/bin/sh
set -e

echo "Cocos OS Dependency Installer"
echo "============================="
echo ""

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Run this script as root / sudo"
    echo "Usage: sudo ./install_deps.sh"
    exit 1
fi

install_packages() {
    echo "Installing packages for $1..."
    echo ""
}

echo "Detecting Linux distribution:"

if [ -f /etc/debian_version ]; then
    install_packages "Debian / Ubuntu / Mint"
    apt update
    apt install -y gcc nasm make binutils qemu-system-x86 genisoimage git

elif [ -f /etc/arch-release ]; then
    install_packages "Arch Linux / Manjaro"
    pacman -Sy --noconfirm gcc nasm make binutils qemu cdrkit git

elif [ -f /etc/alpine-release ]; then
    install_packages "Alpine Linux"
    apk add gcc nasm make binutils qemu-system-x86_64 cdrkit git musl-dev

elif [ -f /etc/gentoo-release ]; then
    install_packages "Gentoo Linux"
    emerge -u sys-devel/gcc dev-lang/nasm sys-devel/make sys-devel/binutils app-emulation/qemu app-cdr/cdrkit dev-vcs/git

elif [ -f /etc/os-release ] && grep -q "Void" /etc/os-release; then
    install_packages "Void Linux"
    xbps-install -Sy gcc nasm make binutils qemu cdrkit git

else
    echo "Unknown distribution"
    echo ""
    echo "Required packages:"
    echo "  gcc, nasm, make, binutils, qemu-system-i386, genisoimage, git"
    exit 1
fi

echo ""
echo "All dependencies installed successfully"
echo ""
echo "Now you can build:"
echo "  make all"
echo "  make run"
echo ""
#!/bin/bash

# Determine the distribution (Dağıtımı belirle)
distro=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Select the package manager and run appropriate commands (Paket yöneticisini seç ve uygun komutları çalıştır)
case "$distro" in
    ubuntu|debian)
        sudo apt update -y && sudo apt upgrade -y
        ;;
    fedora|rhel|centos)
        sudo dnf update --refresh -y && sudo dnf upgrade -y
        sudo yum update -y && sudo yum upgrade -y
        ;;
    arch|manjaro|cachyos)
        sudo pacman -Syyu --noconfirm

        # Update if yay is available (yay varsa güncelle)
        if command -v yay &> /dev/null; then
            yay -Syu --noconfirm
        else
            echo "yay is not installed, skipping. (yay yüklü değil, atlanıyor.)"
        fi

        # Update if paru is available (paru varsa güncelle)
        if command -v paru &> /dev/null; then
            paru -Syu --noconfirm
        else
            echo "paru is not installed, skipping. (paru yüklü değil, atlanıyor.)"
        fi
        ;;
    *)
        echo "Unsupported distribution: $distro (Desteklenmeyen dağıtım: $distro)"
        exit 1
        ;;
esac

# Check if Snap is installed and perform update (Snap yüklü mü kontrol et ve güncelleme yap)
if command -v snap &> /dev/null; then
    sudo snap refresh
else
    echo "Snap is not installed, skipping. (Snap yüklü değil, atlanıyor.)"
fi

# Check if Flatpak is installed and perform update (Flatpak yüklü mü kontrol et ve güncelleme yap)
if command -v flatpak &> /dev/null; then
    sudo flatpak update -y
else
    echo "Flatpak is not installed, skipping. (Flatpak yüklü değil, atlanıyor.)"
fi

# Update completed message (Güncelleme tamamlandı mesajı)
echo "Update completed. (Güncelleme tamamlandı.)"

# Ask the user whether they want to reboot (Kullanıcıya yeniden başlatma isteyip istemediğini sor)
read -p "Do you want to reboot the system? (y/n) (Sistemi yeniden başlatmak istiyor musunuz? (y/n)): " reboot_choice
if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
    echo "Rebooting the system... (Sistem yeniden başlatılıyor...)"
    sudo reboot
else
    echo "Reboot cancelled. (Yeniden başlatma iptal edildi.)"
fi

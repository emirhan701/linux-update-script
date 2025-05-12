#!/bin/bash

# Dağıtımı belirle
distro=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Paket yöneticisini seç ve uygun komutları çalıştır
case "$distro" in
    ubuntu|debian)
        sudo apt update -y && sudo apt upgrade -y
        ;;
    fedora|rhel|centos)
        sudo dnf update --refresh -y && sudo dnf upgrade -y
        sudo yum update -y && sudo yum upgrade -y
        ;;
    arch|manjaro|cachyos)
        sudo pacman -Syu --noconfirm
        ;;
    *)
        echo "Desteklenmeyen dağıtım: $distro"
        exit 1
        ;;
esac

# Snap yüklü mü kontrol et ve güncelleme yap
if command -v snap &> /dev/null; then
    sudo snap refresh
else
    echo "Snap yüklü değil, atlanıyor."
fi

# Flatpak yüklü mü kontrol et ve güncelleme yap
if command -v flatpak &> /dev/null; then
    sudo flatpak update -y
else
    echo "Flatpak yüklü değil, atlanıyor."
fi

# Güncelleme tamamlandı mesajı
echo "Güncelleme tamamlandı."

# Kullanıcıya yeniden başlatma isteyip istemediğini sor
read -p "Sistemi yeniden başlatmak istiyor musunuz? (y/n): " reboot_choice
if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
    echo "Sistem yeniden başlatılıyor..."
    sudo reboot
else
    echo "Yeniden başlatma iptal edildi."
fi

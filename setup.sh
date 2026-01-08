#!/bin/bash

# Update packages
pkg update -y && pkg upgrade -y

# Install required packages
pkg install -y zsh toilet figlet git curl wget

# ---------------- FUNCTIONS ----------------

banner_only() {
cat > ~/.zshrc <<'EOL'
clear
if command -v toilet >/dev/null 2>&1; then
    toilet -f big "KALI LINUX" --metal | sed 's/^/        /'
fi
echo ""
EOL
}

ps1_kali() {
cat >> ~/.zshrc <<EOL
setopt PROMPT_SUBST
PS1="%F{blue}Kali%f%F{red}@${USER_NAME}%f:%~%F{blue}\$( [[ \$PWD == \$HOME ]] && echo '#-' || echo '/-' )%f "
EOL
}

ps1_hacker() {
cat >> ~/.zshrc <<EOL
setopt PROMPT_SUBST
PS1="%F{green}root%f@${USER_NAME}%f:%~ %F{yellow}>>%f "
EOL
}

ps1_simple() {
cat >> ~/.zshrc <<EOL
PS1="%F{cyan}\u@${USER_NAME}%f:%~$ "
EOL
}

extra_keys() {
mkdir -p ~/.termux
cat > ~/.termux/termux.properties <<EOL
extra-keys = [ \
 ['ESC','TAB','CTRL','ALT'], \
 ['~','/','-','_'], \
 ['UP','DOWN','LEFT','RIGHT'] \
]
EOL
termux-reload-settings
}

kali_colors() {
mkdir -p ~/.termux
cat > ~/.termux/colors.properties <<EOL
background=#0a0e14
foreground=#bfbfbf
cursor=#ffcc00
color0=#000000
color1=#ff5555
color2=#50fa7b
color3=#f1fa8c
color4=#bd93f9
color5=#ff79c6
color6=#8be9fd
color7=#bbbbbb
color8=#44475a
color9=#ff6e6e
color10=#69ff94
color11=#ffffa5
color12=#d6acff
color13=#ff92df
color14=#a4ffff
color15=#ffffff
EOL
termux-reload-settings
}

# ---------------- MENU ----------------

clear
echo "=============================="
echo "  Termux Kali Setup Menu"
echo "=============================="
echo "1) Banner + Choose PS1"
echo "2) Extra Keys"
echo "3) Kali Colors Theme"
echo "4) Install Everything"
echo "=============================="
read -p "Enter your choice [1-4]: " main_choice

# If PS1 is chosen, ask for username
if [[ "$main_choice" == "1" || "$main_choice" == "4" ]]; then
    read -p "Enter your username for PS1: " USER_NAME
    clear
    echo "Choose your PS1 style:"
    echo "1) Kali Style (Blue/Red)"
    echo "2) Hacker Style"
    echo "3) Simple Style"
    read -p "Enter PS1 choice [1-3]: " ps1_choice

    banner_only

    case $ps1_choice in
        1) ps1_kali ;;
        2) ps1_hacker ;;
        3) ps1_simple ;;
        *) ps1_kali ;;
    esac
fi

if [[ "$main_choice" == "2" || "$main_choice" == "4" ]]; then
    extra_keys
fi

if [[ "$main_choice" == "3" || "$main_choice" == "4" ]]; then
    kali_colors
fi

chsh -s zsh

echo ""
echo "✅ Setup Complete!"
echo "Restart Termux to see changes."

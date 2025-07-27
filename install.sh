#!/bin/bash

# Kali Setup Script
# Run as the default kali user

set -e  # Exit on any error

echo "Starting Kali CTF setup..."

# Step 2: Update system
echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

# Step 3: Add default user to vboxsf group
echo "Adding kali user to vboxsf group..."
sudo usermod -aG vboxsf kali

# Step 4: Verify shared folder (will check after reboot)
echo "Shared folder verification will be done after reboot..."

# Step 5: Set ZSH as default shell for current user
echo "Setting ZSH as default shell..."
sudo chsh -s /usr/bin/zsh kali

# Step 6-7: Create non-default user (non-interactive)
echo "Creating user 'chris'..."
sudo useradd -m -s /usr/bin/zsh -c "Christopher Ferrari" chris
echo "chris:password123" | sudo chpasswd  # Change this password!
echo "User 'chris' created with password 'password123' - CHANGE THIS!"

# Step 7: Elevate user permissions
echo "Setting user permissions for chris..."
sudo usermod -aG sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev,bluetooth,lpadmin,scanner,vboxsf chris

# Step 10: Install pwntools
echo "Installing pwntools..."
sudo apt install -y python3-pwntools

# Step 11: Create working folders (for both users)
echo "Creating CTF folders..."
mkdir -p ~/CTF/{loot,scripts,tools,notes,boxes}
sudo -u chris mkdir -p /home/chris/CTF/{loot,scripts,tools,notes,boxes}

# Step 12: Install usability tools
echo "Installing usability tools..."
sudo apt install -y fonts-firacode eza

# Step 13: Add CTF aliases to ~/.zshrc (for both users)
echo "Adding CTF aliases..."
cat >> ~/.zshrc << 'EOF'

#CTF Aliases
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
alias loot='cd /media/sf_loot'
alias ls='eza -lh --color=always --group-directories-first'
alias la='eza -lha --color=always --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
EOF

# Add same aliases for chris user
sudo -u chris bash -c 'cat >> /home/chris/.zshrc << "EOF"

#CTF Aliases
alias update="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"
alias loot="cd /media/sf_loot"
alias ls="eza -lh --color=always --group-directories-first"
alias la="eza -lha --color=always --group-directories-first"
alias ..="cd .."
alias ...="cd ../.."
EOF'

# Step 14: Set QTerminal theme to Tango
echo "Setting QTerminal theme..."
mkdir -p ~/.config/qterminal.org
sed -i '/colorScheme=/c\colorScheme=Tango' ~/.config/qterminal.org/qterminal.ini 2>/dev/null || echo 'colorScheme=Tango' >> ~/.config/qterminal.org/qterminal.ini

sudo -u chris mkdir -p /home/chris/.config/qterminal.org
sudo -u chris bash -c 'sed -i "/colorScheme=/c\colorScheme=Tango" /home/chris/.config/qterminal.org/qterminal.ini 2>/dev/null || echo "colorScheme=Tango" >> /home/chris/.config/qterminal.org/qterminal.ini'

# Step 15: Install Catppuccin theme
echo "Installing Catppuccin theme..."
sudo apt install -y python3-pip
curl -LsSO "https://raw.githubusercontent.com/catppuccin/gtk/v1.0.3/install.py"
python3 install.py mocha lavender
xfconf-query -c xsettings -p /Net/ThemeName -s "catppuccin-mocha-lavender-standard+default"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
rm -f install.py

# Step 16: Create wallpapers directory
echo "Creating wallpapers directory..."
mkdir -p ~/Pictures/wallpapers
sudo -u chris mkdir -p /home/chris/Pictures/wallpapers

# Step 17: Set screensaver idle delay
echo "Setting screensaver idle delay..."
xfconf-query -c xfce4-screensaver -p /saver/idle-delay -n -t int -s 30

# Step 18: Set icon theme (this might conflict with step 15, keeping both)
echo "Setting icon theme..."
xfconf-query -c xsettings -p /Net/IconThemeName -s "Flat-Remix-Purple-Dark"

# Step 19: Install MesloLGS NF fonts
echo "Installing MesloLGS NF fonts..."
mkdir -p ~/.local/share/fonts/meslo
cd ~/.local/share/fonts/meslo
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

# Install fonts for chris user too
sudo -u chris mkdir -p /home/chris/.local/share/fonts/meslo
sudo -u chris bash -c 'cd /home/chris/.local/share/fonts/meslo && \
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf && \
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf && \
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf && \
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
sudo -u chris fc-cache -fv

cd ~

# Step 20-21: Install Powerlevel10k and apply custom config
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# Install for chris user
sudo -u chris git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/chris/powerlevel10k
sudo -u chris bash -c 'echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> /home/chris/.zshrc'

# Step 21: Download and apply custom p10k config
echo "Downloading custom p10k configuration..."
curl -fsSL https://raw.githubusercontent.com/Tecttano/dotfiles/main/.p10k.zsh -o ~/.p10k.zsh
echo '[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh' >> ~/.zshrc

# Apply for chris user
sudo -u chris curl -fsSL https://raw.githubusercontent.com/Tecttano/dotfiles/main/.p10k.zsh -o /home/chris/.p10k.zsh
sudo -u chris bash -c 'echo "[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh" >> /home/chris/.zshrc'

# Step 22: Final polish and clipboard alias
echo "Installing xclip and adding clipboard alias..."
sudo apt install -y xclip

# Add clipboard alias for both users
sed -i '/# CTF Aliases/a alias cb='\''xclip -selection clipboard'\''' ~/.zshrc
sudo -u chris sed -i '/# CTF Aliases/a alias cb='\''xclip -selection clipboard'\''' /home/chris/.zshrc

echo ""
echo "Setup complete!"
echo ""
echo "IMPORTANT NOTES:"
echo "1. User 'chris' has been created with password 'password123' - CHANGE THIS!"
echo "2. You need to REBOOT the system for vboxsf group membership to take effect"
echo "3. After reboot, verify shared folder access with: ls /media/sf_loot"
echo "4. After reboot, log in as 'chris' to use the new user account"
echo "5. Run 'source ~/.zshrc' to reload shell configuration"
echo ""
echo "To change chris password, run: sudo passwd chris"
echo "To verify setup after reboot:"
echo "  - sudo ls /root (should work)"
echo "  - ls /media/sf_loot (should show shared folder)"
echo "  - echo 'test' | cb (should copy to clipboard)"

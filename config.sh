# Configure swap

# Install basics
sudo pacman -Sy nano curl git -y

# Install snap
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Install vscde
sudo snap install code --classic

# Install Intellij idea
sudo snap install intellij-idea-community --classic

# Install zsh
sudo pacman -Sy zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins for zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

# Add powerlevel10k in ~/.zshrc
ZSH_THEME=powerlevel10k/powerlevel10k

# Config plugins in ~/.zshrc
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Config powerlevel10k
p10k configure

# Configure git
git config --global user.email "mateusantonioofc@gmail.com"
git config --global user.name "Mateus"

# End
sudo pacman -Syu
source ~/.zshrc

sudo apt install python3.10-venv

# criar e ativar ambiente virtual python
python3 -m venv venv
source venv/bin/activate

# desativar ambiente virtual
deactivate

# instalar dependencias
pip install -r requirements.txt  

# salvar dependencias
pip freeze > requirements.txt

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

# Install ruby
sudo pacman -S base-devel python-pip    
wget http://ftp.ruby-lang.org/pub/ruby/3.0/ruby-3.0.2.tar.gz
tar -xzvf ruby-3.0.2.tar.gz ; cd ruby-3.0.2/ && ./configure   
make && sudo make install
gem install bundler
gem install rails

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


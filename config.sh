# Install basics
sudo apt install nano
sudo apt-get install curl
sudo add-apt-repository ppa:git-core/ppa ; sudo apt update ; sudo apt-get install git

# Install zsh
sudo apt-get install zsh

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

# Install ruby
sudo apt-get install ruby-full ruby-build -y

#install gems
gem install rubocop
gem install rails
gem install bundler
gem install sinatra

# Configure git
git config --global user.email "mateusantonioofc@gmail.com"
git config --global user.name "Mateus"

# End
sudo apt update && sudo apt upgrade
source ~/.zshrc

# Error permission denied in gem install
chmod 777 path

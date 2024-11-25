# Install fonts
git clone --depth=1 https://github.com/terroo/fonts
cd fonts
mv fonts ~/.local/share
fc-cache -fv

# YOUCOMPLETEME
apt install build-essential cmake vim-nox python3-dev gcc g++ make

# PATH YOUCOMPLETEME
cd .vim/plugged/YouCompleteMe  
python3 install.py --clangd-completer

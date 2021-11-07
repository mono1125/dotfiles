#!/bin/bash

curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o /tmp/nvim-nightly
chmod +x /tmp/nvim-nightly
sudo mv /tmp/nvim-nightly /usr/local/bin
echo "Installed /usr/local/bin/nvim-nightly"
echo "add shell config:"
echo 'alias nvim="/usr/local/bin/nvim-nightly"'

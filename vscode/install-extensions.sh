#!/bin/bash

function install_or_update() {
    # answer yes on question to update existing extension
    yes Yes | code --install-extension ${1}
}

# Go mode
install_or_update lukehoban.Go
# Python mode
install_or_update ms-python.python
# Dockerfile mode
install_or_update PeterJausovec.vscode-docker
# Java language support
install_or_update redhat.java
# TOML support
install_or_update bungcip.better-toml
# Rust mode
install_or_update rust-lang.rust
# C/C++ mode
install_or_update ms-vscode.cpptools
install_or_update vector-of-bool.cmake-tools
install_or_update hars.cppsnippets

# icon theme
install_or_update PKief.material-icon-theme

# subword navigation (jumping between upcase letters in camel-case words)
install_or_update ow.vscode-subword-navigation

# wrap comments/text with Alt+Q (toggle auto-wrap with Shift+Alt+Q)
install_or_update stkb.rewrap

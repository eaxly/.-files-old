#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"
GITHUB_REPO_URL="https://github.com/ExtinctAxolotl/dotfiles"

install_dotfiles() {
  info "Trying to detect if dotfiles are installed..."

  if [ ! -d $DOTFILES ]; then
    info "Dotfiles don't exist..."
    if is_installed git; then
			read -p "Do you wan't to install dotfiles? [y/N]" -n 1 answer

			if [ ${answer} != "y" ];then 
				exit 1
			fi

			info "Installing Dotfiles..."
			git clone "$GITHUB_REPO_URL.git" $DOTFILES
		else
			info "Seems like git isn't installed!"
			install_app git
    fi
  fi
}

install_dotfiles
$DOTFILES/install.sh

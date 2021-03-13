#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"
GITHUB_REPO_URL="https://github.com/ExtinctAxolotl/dotfiles"
info() {
	echo -e "${YELLOW}${*}${RESET}"
}

success() {
	echo -e "${GREEN}${*}${RESET}"
}

install_app() {
	info "Trying to find ${1}"
	if ! is_installed_pkg $1; then
		read -p "Do you wan't to install $1? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing ${1}..."
			sudo apt install $1
		else
			info "${1} Will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "${1} is already installed!\nSkipping...\n"
		sleep 1
	fi
}

is_installed_pkg() {
	command -v $1 >/dev/null 2>&1
}

install_dotfiles() {
	info "Trying to detect if dotfiles are installed..."

	if [ ! -d $DOTFILES ]; then
		info "Dotfiles don't exist..."
		if is_installed_pkg git; then
			read -p "Do you wan't to install dotfiles? [y/N]" -n 1 answer

			if [ ${answer} != "y" ]; then
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

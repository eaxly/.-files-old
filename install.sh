#!/usr/bin/env bash

# FANCY COLOOOORS! [·s
x='\033'
RESET="${x}[0m"
CYAN="${x}[0;96m"
RED="${x}[0;91m"
YELLOW="${x}[0;93m"
GREEN="${x}[0;92m"

DOTFILES="$HOME/.dotfiles"
GITHUB_REPO_URL="https://github.com/ExtinctAxolotl/dotfiles"

# informational printer
info() {
  echo -e "${YELLOW}${*}${RESET}"
}

# Error printer
error() {
  echo -e "${RED}${*}${RESET}"

}

# Success printer
success() {
	echo -e "${GREEN}${*}${RESET}"
}

# Checking if a command is installed with command -v
is_installed_pkg() {
  dpkg -s $1 > /dev/null 2>&1
}

is_installed_cmd() {
  command -v $1 > /dev/null 2>&1
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

install_snap() {
  info "Trying to find ${1}"
  if ! is_installed_cmd $1; then
		read -p "Do you wan't to install ${1}? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing ${1}...\n"
			sudo snap install $1
		else
			info "${1} Will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "${1} is already installed!\nSkipping...\n"
		sleep 1
	fi
}

install_flatpak() {
  info "Trying to find ${1}"
  if ! is_installed_cmd $1; then
		read -p "Do you wan't to install $1? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing $1...\n"
			flatpak install $1
		else
			info "${1} Will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "${1} is already installed!\nSkipping...\n"
		sleep 1
	fi
}

install_pip_app() {
	info "Trying to find ${1}"
	if ! is_installed_cmd $1; then
		read -p "Do you wan't to install ${1}? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing ${1}...\n"
			pip3 install $1
		else
			info "${1} Will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "${1} is already installed!\nSkipping...\n"
		sleep 1
	fi
}

install_code() {
	info "Trying to find code..."
	if ! is_installed_pkg code; then
		read -p "Do you wan't to add the apt repositories and install VSCode? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			cd $HOME
			info "Getting gpg key..."
			wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
			info "Trusting Gpg key..."
			sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
			info "Installing VSCode..."
			sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
			sudo apt install apt-transport-https -y
			sudo apt update -y
			sudo apt install code -y
		else
			info "Skipping…\n"
		fi
	else
		success "VSCode is already installed!\nSkipping...\n"
		sleep 1
	fi
}

install_sheldon() {
	info "Trying to find sheldon..."
	if ! is_installed_cmd sheldon; then
		read -p "Do you wan't to install sheldon? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing sheldon..."
			curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
		else
			info "Sheldon will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "Sheldon is already installed!\nSkipping...\n"
		sleep 1
	fi

}

install_spacevim() {
	info "Trying to find spacevim..."
	if [ ! -d $HOME/.SpaceVim ]; then
		read -p "Do you wan't to install spacevim? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing spacevim..."
	   	curl -sLf https://spacevim.org/install.sh | bash
    else
			info "SpaceVim will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "SpaceVim is already installed!\nSkipping...\n"
		sleep 1
	fi
}

install_starship() {
	info "Trying to find starship..."
	if ! is_installed_cmd starship; then
		read -p "Do you wan't to install starship? [y/N] " -n 1 answer
		if [ ${answer} == "y" ]; then
			info "Installing starship..."
      curl -fsSL https://starship.rs/install.sh | bash
      info "INFO!\nIn order to Starship to work properly, you MUST install a nerdfont from https://nerdfonts.com\nTHANK YOU! :D"
    else
			info "Starship will not be installed!\nSkipping...\n"
			sleep 1
		fi
	else
		success "Starship is already installed!\nSkipping...\n"
		sleep 1
	fi
}


install_gui_apps() {
	# install VSCode
	install_code
	# install Snapd
	install_snap authy --beta
	# install Emote
	install_snap emote
	# install firefox
	install_app firefox
	# install font manager
	install_app font-manager
}

install_cli_tools() {
	# install git
	install_app git
	# install zsh
	install_app zsh
	# install sheldon
	install_sheldon
	# install snapd
  install_app snapd
  # install flatpak
	install_app flatpak
	## add flatpak repo
	flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# installing pip3
	install_app python3-pip
	# install bpytop
	install_pip_app bpytop
  # install spacevim
  install_spacevim
  # install starship
  install_starship
}

symlink() {
  read -p "Do you wan't to symlink the configurations from the dotfiles? [y/N] " -n 1 answer
  if [ ${answer} == "y" ]; then
    ln -sf $DOTFILES/src/bpytop/bpytop.conf $HOME/.config/bpytop/bpytop.conf
    ln -sf $DOTFILES/src/sheldon/plugins.toml $HOME/.config/sheldon/plugins.toml
    ln -sf $DOTFILES/src/SpaceVim/init.toml $HOME/.SpaceVim.d/init.toml
    ln -f $DOTFILES/src/starship/starship.toml $HOME/.config/starship.toml
    ln -sf $DOTFILES/src/zsh/zshrc $HOME/.zshrc
  fi
}

on_finish() {
  echo 
  echo
  success "Finished Installing your fresh dotfiles!"
  success "Happy Coding!"
}

main() {
 install_cli_tools "$*"
 install_gui_apps "$*"
 symlink "$*"
 on_finish "$*"
}

main "$*"

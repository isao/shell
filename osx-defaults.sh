#!/bin/sh -eux

which defaults || {
    echo 'must run on a mac, /usr/bin/defaults not in your $PATH'
    exit 1
}

# menu bar: opaque
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# dock
#   pin in corner
defaults write com.apple.dock pinning -string start
#   make icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
killall Dock

# my keyboard shortcuts
# http://hints.macworld.com/article.php?story=20131123074223584
# @ for Command, $ for Shift, ~ for Alt and ^ for Ctrl
#   global shortcuts
defaults write -g NSUserKeyEquivalents -dict-add 'Zoom' -string '@/'

defaults write -g NSUserKeyEquivalents -dict-add 'Hide Sidebar' -string '@~`'
defaults write -g NSUserKeyEquivalents -dict-add 'Show Sidebar' -string '@~`'

#   app shortcuts
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add 'Return to Default Size' -string '@~/'

defaults write com.apple.Mail NSUserKeyEquivalents -dict-add 'Hide Mailbox List' -string '@~`'
defaults write com.apple.Mail NSUserKeyEquivalents -dict-add 'Show Mailbox List' -string '@~`'

defaults write com.apple.AddressBook NSUserKeyEquivalents -dict-add 'Hide Groups' -string '@~`'
defaults write com.apple.AddressBook NSUserKeyEquivalents -dict-add 'Show Groups' -string '@~`'

defaults write com.apple.Finder NSUserKeyEquivalents -dict-add 'Hide Sidebar' -string '@~`'
defaults write com.apple.Finder NSUserKeyEquivalents -dict-add 'Show Sidebar' -string '@~`'


# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Terminal.app
# TODO: read defaults to see if these window and group settings are loaded in
# Terminal.app, and if needed, `open ./terminal/Iy*`
defaults write com.apple.Terminal SecureKeyboardEntry 1
defaults write com.apple.Terminal 'Default Window Settings' 'IyAir'
defaults write com.apple.Terminal 'Startup Window Settings' 'IyAir'
defaults write com.apple.Terminal 'Startup Window Group' 'IyAir2xRHS'
defaults write com.apple.Terminal StartupAction 2
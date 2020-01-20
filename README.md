### Install
Execute in the directory where you cloned this repo:
`for i in $(ls | sed -e '/README.md/d' -e '/powerline_config/d'); do ln -s "$(pwd)/$i" "$HOME/.$i"; done`
`mkdir -p $HOME/.config/powerline && ln -s "$(pwd)/powerline_config" "$HOME/.config/powerline/themes"`

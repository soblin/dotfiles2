# All-in-one

An all-in-one configuration and `dotfiles` for working on other machines, without contaminating the environment (as much as possible).

```
git clone <this> ~/.soblin
```

## dependencies

These commands are not supposed to have bad effects on the envirnoment.

```
sudo apt install tmux tree xclip xsel mlocate htop
```

## bashrc

```
source ~/.soblin/.bashrc
```

## tmux

Use `tmux-soblin` command (declared `.bashrc`).

```
function tmux-soblin() {
    tmux -L soblin -f ~/.soblin/tmux.conf
}

```

- https://stackoverflow.com/questions/21892254/start-tmux-with-command-specify-configuration-file

## emacs

### install

Emacs28/27 should be installed. If it is not provided, use this [ppa](https://github.com/kelleyk/ppa-emacs).

```
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
```

### init

It looks like elpa packages should be placed at `~/.emacs.d/elpa`.

```
git clone https://github.com/soblin/elpa.git ~/.emacs.d/elpa
```

If another person is also using emacs, this may have side effects.

Use `e` command (declared `.bashrc`)

```
function e() {
    if ! emacsclient -nw $@; then
        emacs -q --daemon --load ~/.soblin/.emacs
        emacsclient -nw $@
    fi
}
```

- https://stackoverflow.com/questions/17146844/is-there-a-way-to-specify-custom-init-file-on-emacs-startup

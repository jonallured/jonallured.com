---
favorite: false
number: 59
title: "Updated DigitalOcean Server Setup"
---

I recently wanted to setup a new server and found that [my existing
guide][post-39] needed some updating. The biggest change between that guide and
this one is using Homebrew for installing software but otherwise the overall
approach remains mostly unchanged. Still, I wanted to collect the procedure in
one place so it would make following it easier.

## Create Droplet

Start by using the [DigitalOcean][] interface to create a droplet. I pick the
latest Ubuntu release and the cheapest settings. I do also like to enable
backups in case something terrible happens.

## Root User SSH Setup

When you create a new Droplet, be sure to add your SSH keys and they will be
copied to the root user's `authorized_keys` file automatically. That means you
can SSH into the new server like this:

```
$ ssh root@ipaddress
```

## Create Dev User

To create a user:

```
root@servername:~# adduser dev
```

Use 1Password to set a really long password.

## Add Dev User to Sudo Group

```
root@servername:~# gpasswd -a dev sudo
```

## Add Server to 1Password

Create an entry in 1Password for the server providing both the dev user's
password and the IP Address.

## Copy SSH Keys to Dev User

Since we added our SSH keys to the root user's `authorized_keys` during Droplet
creation, let's copy those keys over to our new dev user:

```
root@servername:~# mkdir /home/dev/.ssh
root@servername:~# cp .ssh/authorized_keys /home/dev/.ssh/
root@servername:~# chown -R dev:dev /home/dev/.ssh/
```

## Configure SSH

We're going to configure SSH so that only our `authorized_keys` will work for
SSH and while we're at it, we're going to disable root login.

```
root@servername:~# vim /etc/ssh/sshd_config
```

Make the following changes:

```
PermitRootLogin no
...
ChallengeResponseAuthentication no
...
PasswordAuthentication no
...
UsePAM no
```

With those changes made, restart the `ssh` service so that they take effect:

```
root@servername:~# service ssh restart
```

## Add SSH Config

In order to make SSHing into the machine easier, add an entry to your SSH
config:

```
$ vim ~/.ssh/config
```

```
Host servername
  Hostname ipaddress
  User dev
```

With those settings, you can now SSH into the machine like this:

```
$ ssh servername
```

## Generating SSH Keys for Dev User

```
dev@servername:~$ ssh-keygen -t rsa -b 4096 -C "jon.allured@gmail.com"
dev@servername:~$ eval "$(ssh-agent -s)"
dev@servername:~$ ssh-add ~/.ssh/id_rsa
```

## Configure GitHub

In order to use SSH on the repos you clone down from GitHub, you'll want to add
the server's public key. There's a nice [write up][ssh-help] on how to do this, but
you'll need to copy the key down to your machine:

```
$ ssh servername 'cat .ssh/id_rsa.pub' | pbcopy
```

Next, head over to the [GitHub SSH Settings page][ssh-page] and add the key.
Then you can confirm that it worked with this:

```
dev@servername:~$ ssh -T git@github.com
```

## Using Homebrew for Managing Software

The major change was that I decided to use Homebrew rather than apt for managing
the software installed on the machine. There are a few requirements we'll want
to install before setting up Homebrew so that looks like this:

```
dev@servername:~$ sudo apt-get update && sudo apt-get -y install build-essential procps curl file git
```

And then we can install Homebrew:

```
dev@servername:~$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then this:

```
dev@servername:~$ eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
```

That will adjust the path such that the current session can see Homebrew. It'll
work for now and my dotfiles will adjust the path moving forward.

## Change Dev User to Use ZSH

```
dev@servername:~$ brew install zsh
dev@servername:~$ command -v zsh | sudo tee -a /etc/shells
dev@servername:~$ chsh -s "$(command -v zsh)"
```

You'll need to log out and back in for this to take affect.

## Install More Software

Kick this off and then do something else because it'll take a while:

```
dev@servername:~% brew install asdf awscli bat fd fzf gh git httpie hub jq rcm the_silver_searcher tmux vim
```

## Create Code Folder

```
dev@servername:~% mkdir code
```

## Install Dotfiles

I'd be lost without my dotfiles so I install them even on my servers:

```
dev@servername:~/code% git clone git@github.com:jonallured/dotfiles.git
dev@servername:~/code% cd dotfiles
dev@servername:~/code/dotfiles% env RCRC=$HOME/code/dotfiles/rcm/rcrc rcup -t linux
```

I also have a file of secrets that needs to come over:

```
$ scp ~/code/secrets/rcm/zshrc.private servername:~/.zshrc.private
```

## Install From Tool Versions

After adding the plugins, a bare install command will get the default versions
all installed for me.

```
dev@servername:~% asdf plugin add ruby
dev@servername:~% asdf plugin add nodejs
dev@servername:~% asdf plugin add python
dev@servername:~% asdf install
```

## Setup VIM

I use vim-plug to manage VIM these days and have a command called replug to get
everything setup:

```
dev@servername:~% replug
```

## Snapshot This Config

You can save the state of a Digital Ocean server by creating a snapshot. To do
this, you first have to power off the machine:

```
dev@servername:~% sudo poweroff
```

Then use the Digital Ocean interface to take your snapshot:

```
Droplets > [Pick Droplet] > Snapshots > Take Snapshot
```

You might want to pick a name like "basic config" or something and then you can
use it to either restore or create new droplets.

One thing I'd note here is that the keys generated for this server will be used
when using this snapshot. When you have a server you want to restore to a known
state, that's a good thing, but when you what to use the snapshot to make a new
server, I'd say those keys should be re-generated.

[post-39]: https://www.jonallured.com/posts/2016/09/09/my-digital-ocean-server-setup.html
[DigitalOcean]: https://www.digitalocean.com/
[ssh-help]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/#platform-linux
[ssh-page]: https://github.com/settings/ssh

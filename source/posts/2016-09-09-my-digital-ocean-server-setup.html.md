---
title: My Digital Ocean Server Setup
favorite: true
---

I wanted to document how I like to setup my [Digital Ocean][do] servers, so here
are those notes.

## Create Droplet

Start by using the Digital Ocean interface to create a droplet - it's that big
green button in the upper right. ;)

These days I'm using Ubuntu 16.04 and I usually do fine with the cheapest box. I
also like to enable Backups in case something terrible happens.

## Root User SSH Setup

When you create a new Droplet, be sure to add your SSH keys and Digital Ocean
will copy them to the root user's `authorized_keys` file automatically. That
means you can SSH into the new server like this:

```
$ ssh root@ipaddress
```

## Create Dev User

To create a user:

```
root@servername:~# adduser dev
```

Use 1Password to set a really long password.

## Add Dev User To Sudo Group

```
root@servername:~# gpasswd -a dev sudo
```

## Add Server to 1Password

Create an entry in 1Password for the server providing both the dev user's
password and the servers's IP Address.

## Copy SSH Keys to Dev User

Since we added our SSH keys to the root users's `authorized_keys` during Droplet
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
root@servername:~# nano /etc/ssh/sshd_config
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

## Generating SSH Keys For Dev User

```
dev@servername:~$ ssh-keygen -t rsa -b 4096 -C "user@example.com"
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

## Install Some Softwarez

```
dev@servername:~$ sudo apt-get update
dev@servername:~$ sudo apt-get install curl git silversearcher-ag tmux vim zsh
```

## Install RVM and Latest Ruby

```
dev@servername:~$ curl -sSL https://get.rvm.io | bash
dev@servername:~$ rvm install 2.3.1
```

## Change Dev User to use ZSH

```
dev@servername:~$ chsh -s /bin/zsh
```

You'll need to log out and back in for this to take affect.

## Create Code Folder

```
dev@servername:~% mkdir code
```

## Install dotfiles

I'd be lost without the Hashrocket dotfiles and commands, so I have to have them
on the servers I setup:

```
dev@servername:~/code% git clone git@github.com:hashrocket/dotmatrix.git
dev@servername:~/code% cd dotmatrix
dev@servername:~/code/dotmatrix% bin/install
```

But then I also like to add my own:

```
dev@servername:~/code% git clone git@github.com:jonallured/dotfiles.git
dev@servername:~/code% cd dotfiles
dev@servername:~/code/dotfiles% rake install
```

## Install Vimbundles

Once you've got dotmatrix setup, install your vim plugins:

```
dev@servername:~/code% hr vimbundle
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

[do]: https://www.digitalocean.com/
[ssh-help]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/#platform-linux
[ssh-page]: https://github.com/settings/ssh

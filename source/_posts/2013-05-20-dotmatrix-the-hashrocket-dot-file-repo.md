---
date: 2013-05-20 07:07
number: 75
tags: crosspost
title: "Dotmatrix: The Hashrocket Dot File Repo"
---
*Note: crossposted from [Hashrocket's Blog][hashrocket-link] for posterity.*

At Hashrocket we love our tools and pride ourselves on being good at using them.
One way we go about getting good with these tools is by customizing them with
some great configuration. [Dot files][wikipedia] are used by many programs to
configure behavior and [sharing these dot files on GitHub][dotfiles-on-github]
is a nice way for developers to have a consistent development environment.

We share our dot files in a project called [Dotmatrix][]. Its been around for
[quite a while][initial-commit] and been contributed to by [many current and
former Rocketeers][contributors]. It's the distillation of the taste of quite a
few very picky programmers. It's easy to install, upgrade and use all or just
parts of it and there's lots of cool stuff in there even if you just want to
read through it a little.

## What is Dotmatrix?

Dotmatrix is really two things:

1. A vehicle for keeping a set of dot files in sync
2. Version history of the contents of these dot files

It's the thing you use to install and upgrade a set of dot files and it's also a
git repo of those actual dot files. Some of it concerns the installation and
upgrading of these files and the rest of it is those actual dot files.

## Local Versions of A Dot File

Every program is different, but for the most part, they have a load order for
their configuration. Most support both a config file and a local version. Take
your Z shell config--its specified in this file: `~/.zshrc`, but if you have a
file called `~/.zshrc.local`, that local file will get a chance to override the
normal version.

The bottom line is that you can inherit configuration in the `~/.zshrc` and then
have your local modifications in `~/.zshrc.local`.

## Before You Install Dotmatrix

It's likely that you already have some configuration in your dot files, so
before you install Dotmatrix, pull that configuration into a local version.
Better yet, create a repo of those local dot files!

For example, if you already have some configuration in your `~/.zshrc` file, but
want to use Dotmatrix, then move your file to a local version:

```
$ mv ~/.zshrc ~/.zshrc.local
```

Take a look at the [list of files][file_list] in Dotmatrix and then look at your
own configuration to see which files you'd like to maintain a local version of.

## Installation

Installing Dotmatrix on a brand new machine is easy. Start by cloning the repo
down, maybe in a ~/Project folder or something like that:

```
$ git clone git://github.com/hashrocket/dotmatrix.git
```

Then just go into that directory and run `bin/install`.

This installer script will respect local versions of dot files and then create
symlinks to its set of dot files.

If a given dotfile already exists, then that particular file will NOT be
over-ridden. On the one hand, this is nice because you can't accidentally lose
something, but it also means that you wont get some of the goodies in dotmatrix
if you unwittingly leave a dot file around, so pay attention to the output to
ensure it's doing what you want.

## Upgrading

To upgrade your dotmatrix install go back to the folder where you cloned it and
run `bin/upgrade`. It will fetch the latest and greatest from the GitHub repo
and then run the installer script all over again.

## For Vim Users

Another big part of Dotmatrix is the Vim setup that's been built-in. To get this
part, after an install or upgrade run this:

```
$ bin/vimbundles.sh
```

We use a LOT of Vim plugins and this will grab those and get you all set.

## Partial Install

Maybe you'd like to just grab some of the files in Dotmatrix, maybe just our Git
shortcuts, for example--no prob, just do a [partial install][partial]!

This is great for those that are new to Dotmatrix and want to just check out
some part of it, here are some partial installs that might work for you:

### Just Git Config

Create a file called `FILES` in the Dotmatrix folder with just this line:

```
.gitconfig
```

This will get you our Git aliases and some other cool configuration.

### Just Vim Config

To grab just the Vim parts of Dotmatrix, create that same `FILES` file in the
Dotmatrix folder and have this in it:

```
.vim
.vimrc
```

And then be sure to run the `bin/vimbundles.sh` command.

### Just ZSH Config

Maybe you've heard great things about Z shell and want to try it out--no prob,
grab our ZSH config and you'll be glad you did. Put this in the `FILES` file:

```
.hashrc
.zsh
.zshrc
```

Don't forget to run `chsh -s /path/to/zsh` too--that's what switches your shell.

## Under Active Development

So, that's Dotmatrix--give it a spin and I think you'll find some great stuff.
One last thing to note is that this project is fairly active, so be sure to
upgrade often for the latest goodies!

[Dotmatrix]: https://github.com/hashrocket/dotmatrix/
[contributors]: https://github.com/hashrocket/dotmatrix/graphs/contributors
[dotfiles-on-github]: http://dotfiles.github.io/
[file_list]: https://github.com/hashrocket/dotmatrix/blob/master/bin/file_list.sh
[hashrocket-link]: https://hashrocket.com/blog/posts/dotmatrix-the-hashrocket-dot-file-repo
[initial-commit]: https://github.com/hashrocket/dotmatrix/commit/9b1a5e54f80cf752e4ce696bd20444da07bf2ab7
[partial]: https://github.com/hashrocket/dotmatrix#partial-installation
[wikipedia]: http://en.wikipedia.org/wiki/Dot_files

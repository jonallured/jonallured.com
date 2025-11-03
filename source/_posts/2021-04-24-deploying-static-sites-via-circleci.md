---
favorite: true
number: 55
title: "Deploying Static Sites via CircleCI"
---

Hosting static sites at DigitalOcean has been working out great for me but I
wanted to make it even better so I've set them up to build and deploy at
CircleCI on merges to the main branch. Here I'll outline how I do this.

## Configuration Updates

My approach is to have a `deploy` job in the CircleCI config that sends the
freshest build of my site to DigitalOcean. The formula for this operation is
something like this:

1. install rsync
1. add ssh keys
1. scan the DigitalOcean server for keys and update known hosts
1. build the site using Middleman
1. deploy the site using rsync

Here's an example of these steps:

{% raw %}
```yaml
steps:
  - run:
      name: Installing rsync
      command: sudo apt-get update && sudo apt-get install -y rsync

  - add_ssh_keys

  - run:
      name: Scan server keys
      command: touch ~/.ssh/known_hosts && ssh-keyscan jonallured.com >> ~/.ssh/known_hosts

  - checkout

  - restore_cache:
      name: Restore bundler cache
      key: bundler-v2-{{ checksum "Gemfile.lock" }}

  - run:
      name: Bundle install
      command: bundle install --jobs=4 --retry=3 --path vendor/bundle

  - run:
      name: Deploying site
      command: bundle exec rake deploy
```
{% endraw %}

See also [my complete CircleCI config][config] file for this site.

[config]: https://github.com/jonallured/jonallured.com/blob/853feb355ff45b2b8d870e40a498139e99c0f652/.circleci/config.yml

## Setting Up SSH Keys

In order to safely allow CircleCI to deploy the site to DigitalOcean we have to
generate and set some SSH keys. Start by creating a key pair like so:

```
$ ssh-keygen -m PEM -t rsa -C "jonallured-com@circleci" -f keys/circleci/jonallured-com
```

I do this in a `~/code/secrets` folder on my machine and then check in these
keys. This is an end-to-end encrypted git repo outside any particular project
and I host it with Keybase.

Next up let's send the public key to our DigitalOcean server and update the
authorized keys file there:

```
$ ssh-copy-id -i keys/circleci/jonallured-com.pub psylocke -f
```

Then upload the private key in the CircleCI interface:

{%
  include
  wrapped_image.html
  alt="Add SSH Key Screen in CircleCI Settings."
  src="/images/post-55/circleci-ssh-key.png"
%}

Make sure you add the ENV var at CircleCI too:

```
DEPLOY_TARGET=dev@jonallured.com:/var/www/jonallured.com
```

And that should correspond with the keyscan command in the yaml config so that
the deploy doesn't hang on waiting for a yes/no answer on accepting the identity
of the host.

## Deploying The Site

I've got a rake task that builds and deploys the site:

```ruby
desc 'Deploy site'
task :deploy do
  system 'middleman build --clean'
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end
```

At this point our next steps will be to create a PR, get it merged to main and
then our servers should be doing things automatically for us!

---
layout: post
title: Setting Up a New Rails Application
published_at: Wednesday, October 17, 2012
---

When I'm starting a new Rails project I have a particular way I like to set things up and I wanted to document it mostly for myself, but maybe others will find it interesting and pick up a tip or two. Like most things in tech, there's a million ways to do this, this is just my preferred way of doing it--your mileage may vary.

Guiding Principles
------------------

I've previously written about [what I suggest one should consider](http://jonallured.com/2012/08/31/how-to-think-about-your-local-dev-environment.html) when working locally and that's a good place to start when getting a new project together. I like to think about production right away and since I exclusively deploy to [Heroku](http://heroku.com/) these days, I might actually start a project by visiting [their Add-on page](https://addons.heroku.com/) and seeing what I'll need.

Why Heroku
----------

There are lots a ways to deploy, but at work and on my own stuff, I use Heroku. Heroku is a great hosting company and there are many advantages to using this platform, but for me it mostly comes down to one thing: your first dyno is free. This means that if you are ok with a dyno that goes to sleep after an hour of inactivity, then you can host on their service for free.

If I've got some goofy idea for an app or I want to learn some new technique or tool, then a toy app is a great way to do that. I'm not going to want to pay for big-boy hosting on something like that, I probably just want something easy and free. Heroku is a no-brainer here. Then, since I'm already there, if I need more I'll probably just stay there and pay their very affordable rates. Its a stupid-simple and very smart strategy on their part.

Ruby Version
------------

Now that [Heroku's Cedar Stack is GA](http://blog.heroku.com/archives/2012/5/24/cedar_goes_ga/), I use it for all my new projects. And since they [support defining a Ruby version in your Gemfile](http://blog.heroku.com/archives/2012/5/9/multiple_ruby_version_support_on_heroku/), I usually start by picking which version of Ruby I'm going to use and at this point, its 1.9.3. [RVM](https://rvm.io/) is how I manage my Rubies locally, so my first step on any new project is usually to setup RVM:

	$ rvm use --create 1.9.3-p194@myapp

Note: at the time of writing this, patch 194 was the latest 1.9.3, but it doesn't matter.

This will switch you over to the latest 1.9.3 and create a [Gemset](https://rvm.io/gemsets/basics/) for your app. A Gemset is a great way to keep the Gems for an application isolated--gems installed in a particular Gemset are not available in any others, so you can keep particular versions of a Gem in sync with your application.

Creating the App
----------------

Next I grab the latest Rails:

	$ gem install rails

Then I can new up my application:

	$ rails new myapp --skip-bundle -d postgresql -T -m https://raw.github.com/jonallured/rails_template/master/template.rb

The Rails help is pretty good, but I'll quickly describe the flags I'm using here and why:

* `--skip-bundle`: by default Rails will run `bundle install` as one of the last steps when running through the steps for creating a new app and since I usually want to futz with that file, I'd rather run this myself when I'm done.

* `-d postgresql`: this is probably self-explanatory, this flag tells Rails that you'll be using Postgres as your database. For most applications, this makes sense because I'm going to be working with relational data, but you can specify others too. What's important to me is that if I'm going to run Postgres in production, I should be running Postgres locally for development.

* `-T`: this flag tells Rails to skip Test::Unit files--I use Rspec instead.

* `-m [url]`: the last flag here is specifying a rails template to use.

Rails Template
--------------

I think Rails templates are pretty cool--they are just Ruby files that are run at the end of the Rails new process. You can pretty much do anything you can do in Ruby there, so they offer a lot of freedom. If you take a peek at [my Rails template](https://github.com/jonallured/rails_template/blob/master/template.rb), you'll see the following going on:

* setup an `.rvmrc` file for the project, there's an extra line here setting an environment variable, but we'll come back to this later.

* remove the database config file Rails poops out, create an example one, copy this example one and then ignore it in Git

* pull down some standard Rake tasks

* update the Gemfile with a bunch of Gems I usually use and then specify the version of Ruby to use

* initialize a Git repo for the app

Since there's not much variation on how I do these things, I think they are perfectly suited for a template. If I know there are changes I'm going to make I'll sometimes curl it down and make those changes and then refer to it locally instead.

Initial Commit
--------------

Now when I `cd` into the app I should be prompted to trust the `.rvmrc` file and it will automatically be loaded when I get into the app in the future. So now we'll get in there, bundle and make our initial commit.

	$ cd myapp
	<trust the .rvmrc file>
	$ bundle install
	$ git add .
	$ git commit -m "Initial commit"

I think this is a good place for an initial commit, but if you like to do more setup before you commit, you can wait too.

More Gems, Cleaning Gemfile
---------------------------

I get nice defaults from the Rails template I used, but if there's a Gem I know I'm going to need right away, I might do that installation now, committing after each install.

I have a particular way I like to organize my Gemfile, here's what my default one would look like:

	source :rubygems
	
	ruby '1.9.3'

	gem 'rails', '3.2.8'
	gem 'pg'
	gem 'thin'

	gem 'decent_exposure'
	gem 'haml-rails'
	gem 'jquery-rails'

	group :assets do
	  gem 'coffee-rails', '~> 3.2.1'
	  gem 'sass-rails',   '~> 3.2.3'
	  gem 'uglifier', '>= 1.0.3'
	end

	group :development do
	  gem 'rails-erd'
	  gem 'heroku'
	end

	group :development, :test do
	  gem 'fabrication'
	  gem 'pry_debug'
	  gem 'pry-rails'
	end

	group :test do
	  gem 'cucumber-rails', require: false
	  gem 'database_cleaner'
	  gem 'rspec-rails'
	end

The first five lines are pretty standard: first the source line, then the ruby line and last I want to see the version of rails, the database Gem (or Gems if you're going to be all polyglot about it) and then the server. I like this stuff right at the top so that if someone new comes to the project, they can at-a-glance see this stuff easily.

After that I list the rest of the Gems for all environments and then the Gems for particular environments. I keep these lists in alpha order.

Setting Up the Database
-----------------------

Before we go any further, lets take a second to create our development and test databases. First open open that database.yml file our template made for us and enter the correct info for your setup. Then, just run the rake commands:

	$ rake db:create && rake db:migrate && rake db:test:prepare

The Heroku Applications
-----------------------

Now that I've got a repo, I can create my production environment:

	$ heroku apps:create myapp -r production --addons pgbackups:plus,sendgrid:starter

Depending on what I'm working on, I'd probably also create a staging environment the same way:

	$ heroku apps:create myapp-staging -r staging --addons pgbackups:plus,sendgrid:starter

I used to need to specify a few addons that I'm always using but at this point both [Logging](https://devcenter.heroku.com/changelog-items/11) and [Release Management](https://devcenter.heroku.com/changelog-items/9) are both platform features, so its just the [PG Backups](https://addons.heroku.com/pgbackups) addon that I need. But most apps are going to work with Email, so I tend to throw [Sendgrid](https://addons.heroku.com/sendgrid) in there too.

If you've never worked with two Heroku apps on the same Rails application, you'll quickly learn that in order for the Heroku gem to know which one you want to run a given command for, you have to specify it. There are two ways to do this, say we wanted to review the config for our staging application, we could do this by specifying the remote or the app name:

	$ heroku config --remote staging
	$ heroku config --app myapp-staging

But Heroku loves us and knows that this is a pain in the ass, so they recently introduced an environment variable called `HEROKU_APP` that you can specify and the Gem will use that over any flags you give it. That's why back in our template I noted that I set this in the .rvmrc file--this is a very convenient place for this, but you can set it another way if you prefer. Regardless, once set, you'll only have to specify the app you want your command run on when its different than the default one. I tend to set this to my staging app and then I specify the production app when I want to work with it.

GitHub Repo
-----------

At this point I think its time to push things out, so I like to setup a GitHub repo and add a remote for it. Once that's done lets get our initial commit pushed out:

	$ git push origin
	$ git push staging
	$ git push production

That'll update both GitHub and the Heroku applications and our code is now out in the wild.

Rake Tasks
----------

So, we did push out to Heroku, but I've actually got Rake tasks that I like to use for deploying. These were pulled down with the template and so we actually have this:

	$ rake deploy

And running that task goes through the following steps:

* Turn on [Heroku's maintenance mode](https://devcenter.heroku.com/articles/maintenance-mode)
* Push the repo to Heroku
* Run `rake db:migrate`
* Turn off maintenance mode
* Restart Heroku

There's a task for deploying to production, to staging and the default does staging. The maintenance mode might be overkill, but especially in production, it might be required. I'm forever forgetting to run migrations, so I threw that in there and then I've had problems where code was cached until I restarted Heroku so I just do it every time.

Now what I'm thinking about is getting the default Rake task working, but that means I need to install Cucumber and Rspec.

Default Rake Task and Tests
---------------------------

What I want is for the default Rake task to run my specs and then my features. To do this, we first need to install both Cucumber and Rspec:

	$ rails g cucumber:install
	$ rails g rspec:install

Mostly I just stick to standard stuff here, but there are a few things I tweak. Firstly, I like for rake to output dots, so I add this line to the Cucumber config file (config/cucumber.yml):

	rake: --format progress --strict --tags ~@wip features

Then in the Cucumber rake file (lib/tasks/cucumber.rake) I change the `ok` task to use this profile. Also, remove the default task line.

Earlier in our template we pulled down an Rspec task that mimics the Cucumber one that gets added when you install that Gem, so at this point we just need to set the defaults. Add this to your Rakefile:

	task default: [:spec, :cucumber]

Now we can test that everything's wired up correctly by running the default task:

	$ rake

What I want to see here is that both specs and features were looked for and nothing was found.

Moving Data Between Environments
--------------------------------

The last thing I wanted to cover was that rake task we installed for syncing Postgres databases. Now, this task does assume you're using Heroku, so bear that in mind. But what I run into is wanting to pull down production data to either replicate a bug or test that some migration will work there and this task helps with that. What you do is run `rake pg_sync:production_to_local` and since you're using Postgres locally (you are, right?), it'll just dump that data down and off you go.

You'll also get tasks to send data from production to staging and from staging down to your local.

This is Just a Start
--------------------

At this point I've probably committed a few times but now I'd be ready to start putting in stuff that's specific to the application and know that the application is setup the way I've come to expect.
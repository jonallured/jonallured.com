---
favorite: false
number: 3
title: Using Devise for Admin Accounts
---

I use [Devise][devise] on almost every Rails project I work on and wanted to
share some things I've learned about using it - specifically, how I use it for
Admin accounts. Devise is a gem that creates user models and handles all the
authentication that goes along with them. It also does things like password
retrieval and account confirmations and it does all this in a very friendly,
modular way where you can pick which parts your app needs. The team working on
it has done a fabulous job with not only the code but also the documentation. I
can't recommend it highly enough or thank them enough for what they've
contributed to the Rails community.

One thing you'll probably run into while building a typical app using this gem
is needing a way to protect screens so that only administrators can get to them.
Many CRUD screens, reports and anything related to the content are all prime
candidates to get some admin love. There's a [page on the Devise
wiki][wiki_admin] explaining two techniques you can use to create Admin accounts
and you should start by reading that.

## You Really Need an Admin Model

<p class="listHeading">The two techniques described are:</p>

* create a separate Admin model
* add an admin boolean to your existing User model

There are always exceptions and I'm glad they mention the second approach, but I
find it completely unrealistic. Your project doesn't have to get very
complicated before you'll wish that you had your own model.

Its clean to start with something like `if current_user.admin?` and I think that
clarity and the ease of just running a quick migration could be attractive to
someone starting out, but its not long before you find yourself with a mess like
this:

```ruby
if current_user.admin? and !current_user.reports_only? and current_user.edit_content?
```

My advice is to take the plunge and do an Admin model right off the bat. You
might feel like its a waste, like its more than you need, but if requirements
change (don't they always?) and a little more complexity is introduced, you'll
be glad you have a separate model.

## You Might Need a Permission Library

This piece talks about light permission needs - I'm talking about like three
cases here, nothing crazy. If you have really complicated permission needs,
you'll want to pursue other options, something like [CanCan][can_can]. There's
even a [page on the Devise wiki][wiki_can_can] to help you get started, so check
that out.

But here, we're just talking about basic permission needs.

## Different Kinds of Admin

Its just going to happen, you're going to end up with different kinds of Admin
accounts. It happens because there will be people that should have access to one
thing but not another. You'll have people in the Marketing department that need
to edit content, but they shouldn't see your CRUD screens for managing User
objects or maybe you've got raw scaffold pages for some objects that expose ids
or something like that.

You'll have someone from Accounting that just needs to run a report every month
or a manager that wants to see a list of new accounts and they shouldn't be let
anywhere near content, not to mention your screens.

You'll continue to create screens that are easier than the command line for
things you do frequently and you aren't going to want anyone messing around in
there besides people that know what they are doing.

<p class="listHeading">You could create a different Devise user type of each of these, but I find that approach ends up being too much. And when there are overlaps about who can see what, its weird to code. Before we move on, lets summarize:</p>

* its important to have an Admin model so that as things get more complex you
  have something to hang some logic on
* there are different kinds of admin users, but don't go crazy and create a
  model for each type
* the easiest type of admin is the business person who just has access to run reports
* then you've got you: you have access to everything
* finally, you've got the normal admin, they don't see your screens, but they
  can edit some content and run reports too

## Generating Your Admin

This is the Rails Generator command I use:

```
$ rails g devise Admin god_mode:boolean reports_only:boolean
```

I use `god_mode` to indicate that its me or another programmer and I use
`reports_only` to indicate a user that shouldn't be editing stuff, just running
reports. If an Admin has false for both of these then they are the normal Admin
that can edit content and run reports but don't have access to programmer stuff.
Easy.

## The Admin Model

The suggestion from the wiki is to use the `:trackable`, `:timeoutable` and
`:lockable` modules, which I think its too much, but review each and see what's
right for your project. Choices like this are what's great about Devise - if you
have a need for these things, then you can easily mix them in.

But for me, I end up with a model that looks like this:

```
class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable
  attr_accessible :email, :password, :password_confirmation, :god_mode, :reports_only
end
```

So, I do add the `:rememberable` module because I like it and more importantly
the Marketing and Accounting people like it.

I think its important to point out something here: we're not including the
`:registerable` module, which means routes like `/admins/sign_up` aren't going
to work. This is one of the ways you are protecting yourself. Admin accounts can
only be created from the command line with a command like:

```
>> Admin.create(:email => 'user@domain.com', :password => 'shhhhh', :god_mode => true, :reports_only => false)</code></pre>
```

## The Admin Migration

Almost there, but before we run the migration that the Generator created for us,
the wiki guides us to remove a few things. I like to add defaults for the two
booleans, so my migration looks like this:

```ruby
class DeviseCreateAdmins < ActiveRecord::Migration
  def self.up
    create_table(:admins) do |t|
      t.database_authenticatable :null => false
      t.rememberable
      t.boolean :god_mode, :default => false
      t.boolean :reports_only, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
```

With your migration updated, you should be all set to run a `rake db:migrate`
and then go to the console and create an Admin account for yourself.

## You Will Need Views

Just a couple more things to finish. I like to go verify that Devise added the
route correctly and actually I usually end up shifting things around because I
like to see the Admin route right next to the User route. Not a big deal, just
make sure everything's cool in your routes.rb file.

Next its time to talk about views. Lets assume you're reading this before you
implement, that'll mean that you haven't generated any views yet and you can
issue a command like this:

```
$ rails g devise:views admins
```

The [Devise README][readme] covers this under the aptly named Configuring Views
heading - go read all the juicy details. What you want is for all your User
views to live under /app/views/users and all your Admin views to live under
/app/views/admins.

If you are reading this while in the middle of development and you've already
generated views for your User model, they will be under /app/views/devise, but
that's ok, you can still issue the above command and you'll get your Admin views
under /app/views/admins - just remember where each set of views lives and you'll
be all good.

## Now Use It

The obvious way to use all this is to add the default Devise before filter:

```ruby
before_filter :authenticate_admin!
```

Any controller protected that way will redirect to the sign in page unless an
Admin is logged in. You can always use either the `only` or the `except`
keywords to pick out controller actions that aren't Admin only. This level of
protection lets Marketing, Accounting and you all in.

For your stuff you could add another before filter like this:

```ruby
before_filter :ensure_god_mode

def ensure_god_mode
  redirect_to admin_root_path unless current_admin.god_mode?
end
```

That'll make sure only you and your fellow programmers have access.

For the Accounting people, I tend to use a different approach. For them, I end
up blocking things at the view level. I'll have an Admin dashboard kind of page
that lists things Admin can do and this is how I block them:

```html
<p>Here are the things you can do:</p>
<ul>
  <li>[something every admin can do]</li>
  <% unless current_admin.reports_only %>
  <li>[something business people shouldn't mess with, maybe a link to edit content?]</li>
  <% end %>
  <li>[another thing any admin can do, maybe a report?]</li>
</ul>
```

There are lots of ways to use your Admin model and the booleans, theses are just
a couple patterns I've seen myself using.

## One Last Fun Thing

Hopefully these notes will help someone figure out how to create Admin accounts
that work for their project, I know I've been happy with this approach. I like
to keep things fun with my code, so the last thing I wanted to share is an
addition I make to the application layout file:

```html
<%= "<p id=\"godModeNotice\">GOD MODE ACTIVE!</p>".html_safe if current_admin.god_mode? %>
```

You'll need to tuck it into an `if admin_signed_in?` block, but it should get a
snort of appreciation from the programmer sitting next to you when he sees it.
And its fun when normal Admins see it too.

[devise]: https://github.com/plataformatec/devise
[wiki_admin]: https://github.com/plataformatec/devise/wiki/How-To:-Add-an-Admin-role
[can_can]: https://github.com/ryanb/cancan
[wiki_can_can]: https://github.com/ryanb/cancan
[readme]: https://github.com/plataformatec/devise/blob/master/README.md

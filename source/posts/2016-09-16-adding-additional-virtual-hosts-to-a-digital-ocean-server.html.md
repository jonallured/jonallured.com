---
title: Adding Additional Virtual Hosts to a Digital Ocean Server
favorite: true
---

The [Apache Virtual Hosts tutorial][tutorial] for setting up your [Digital
Ocean][do] server is really good, but when you want to add an additional site
it's a little more than you need. To cut down on the clutter, I've written down
my notes for what's required to setup additional sites.

## Add Content

Start by creating the folder where your HTML content will live:

```
$ sudo mkdir /var/www/example.com
$ sudo chown -R $USER:$USER /var/www/example.com
```

Then fill that folder with whatever content you're planning on serving.

## Site Configuration

Here's my basic configuration for a virtual server:

```
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
<VirtualHost *:80>
  ServerName example.com
  DocumentRoot /var/www/example.com
</VirtualHost>
```

There are a TON more options, but that usually does the trick. Copy that over to
your new site:

```
$ sudo cp /etc/apache2/sites-available/my-basic.conf /etc/apache2/sites-available/example.com.conf
```

And then replace the example.com parts:

```
$ sudo vim /etc/apache2/sites-available/example.com.conf
```

## Enable Site and Restart Apache

All that's left is to enable the new site and restart apache:

```
$ sudo a2ensite example.com.conf
$ sudo systemctl restart apache2
```

[tutorial]: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-16-04
[do]: https://www.digitalocean.com/

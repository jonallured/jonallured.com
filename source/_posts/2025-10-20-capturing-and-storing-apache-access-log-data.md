---
date: 2025-10-20 13:44 -0500
favorite: false
number: 69
title: "Capturing and Storing Apache Access Log Data"
---

My static sites are served by a Digital Ocean server that uses good old
fashioned Apache to serve the content. I have configured that server to capture
access log data and the store it on S3.

## Apache Access Logs

In the world of Apache webservers the access log file is the standard location
to store the requests that the server processes. In my case this configuration
starts here:

```
# from /etc/apache2/apache2.conf
# ...
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
# ...
```

You can read this line like this:

* first is `LogFormat` which indicates this line will be defining a format
* next is a quoted string with the format
* last is the name of the format - `vhost_combined` in this case

I didn't write this - this comes standard with a brand new setup. Because I was
lazy I ended up copy/pasting this line with the format name of `combined` to
save myself a bit of work so remember that for later.

Next stop is to the individual site configurations. Here's one:

```
# from /etc/apache2/sites-available/jonallured.com.conf
<VirtualHost *:80>
  # ...
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  # ...
</VirtualHost>
```

This can be read like so:

* first is `CustomLog` which indicates this line will be defining how to handle
  log data
* next is a path to the file where we should log
* last is the name of the format to use

So this is where I was lazy. All the sites that this machine serves have this
same configuration and so rather than updating each one to reference
`vhost_combined` I just setup the `combined` format to include the website name.
There's probably a better way to do this but that's for another time.

The punchline is that with these 2 pieces of configuration in place the server
is now setup to log incoming requests in a standardized way.

## Some Sample Data

I will be diving much more deeply into the data in a future post but here's an
example of a logged request for the curious:

```
www.jonallured.com:443 64.71.157.102 - - [26/Jun/2021:00:12:48 +0000] "GET /atom.xml HTTP/1.1" 200 18560 "-" "Feedbin feed-id:2032942 - 1 subscribers"
```

This line decodes like this:

* website: `www.jonallured.com`
* port: 443
* request ip: 64.71.157.102
* identity: -
* user: -
* request timestamp: [26/Jun/2021:00:12:48 +0000]
* first line of request: "GET /atom.xml HTTP/1.1"
* response status: 200
* response size: 18560 (in bytes)
* request referrer header: "-"
* request user agent header: "Feedbin feed-id:2032942 - 1 subscribers"

Kinda cool! This is a request from Feedbin for the RSS feed of my blog on behalf
of my 1 and only subscriber - me. <3

## The logrotate Tool

The next piece of the puzzle is to take the stream of request logging and rotate
it such that each day has an individual file. Turns out there is a pretty
standard CLI tool for this called `logrotate`. In order to get these Apache
Access Logs rotating I configured it like so:

```
# from /etc/logrotate.d/apache2
/var/log/apache2/*.log {
        daily
        missingok
        rotate 14
        compress
        delaycompress
        notifempty
        create 640 root adm
        sharedscripts
        dateext
        postrotate
                if invoke-rc.d apache2 status > /dev/null 2>&1; then \
                    invoke-rc.d apache2 reload > /dev/null 2>&1; \
                fi;
        endscript
        prerotate
                if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
                        run-parts /etc/logrotate.d/httpd-prerotate; \
                fi; \
        endscript
        lastaction
                AWS_SHARED_CREDENTIALS_FILE=/home/dev/.aws/credentials aws s3 sync /var/log/apache2/ s3://mli-data/domino/logs --exclude "*" --include "*.gz"
        endscript
}
```

There's a lot here but the important parts are that this configuration will pick
up the access log file that Apache is writing to and rotate it daily but only
keep the 14 most recent files. It compresses them as they are rotated and adds a
date to the resulting filename so it is easy to know which one is from which
day. It also includes some restarting of Apache.

With this in place we can see the logging and rotation in action by listing the
log directory:

```
dev@domino:~% ls -1 /var/log/apache2
access.log
access.log-20251007.gz
access.log-20251008.gz
access.log-20251009.gz
access.log-20251010.gz
access.log-20251011.gz
access.log-20251012.gz
access.log-20251013.gz
access.log-20251014.gz
access.log-20251015.gz
access.log-20251016.gz
access.log-20251017.gz
access.log-20251018.gz
access.log-20251019.gz
access.log-20251020
```

The first file is the one currently being written to by Apache. The next set of
files that end with a `.gz` extension are the ones that have been archived and
compressed. The last one is the partially rotated file that will become archived
once the day is complete.

## Uploading to S3

Let's look at a section from the `logrotate` config that I skipped - the part
that sends the log data to S3 and here it is in isolation:

```
lastaction
        AWS_SHARED_CREDENTIALS_FILE=/home/dev/.aws/credentials aws s3 sync /var/log/apache2/ s3://mli-data/domino/logs --exclude "*" --include "*.gz"
endscript
```

This section instructs `logrotate` to run this command as the last part of the
rotation process. The purpose of the command is to take what's been rotated and
sync it to a bucket on S3 for processing elsewhere. I start by passing an ENV
var to a set of AWS credentials that have been generated for this purpose. Then
I run the `aws s3 sync` command and pass the local path to the Apache access
logs and the bucket path where I want them to go. The final part is 2 flags to
exclude all files and then only include those files that end with `.gz` so that
I ignore all but the compressed and fully rotated files.

At this point we have a solid configuration for the webserver and a lot of data
on S3 with which to construct some analytics for these static sites.

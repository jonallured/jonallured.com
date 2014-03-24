---
title: Keeping a Live Website in Sync with a Local Version, Part Two
---

*This part covers the technical aspects of a project I worked on to keep a live website in sync with a local version, [the first part](/2011/08/08/keeping-a-live-website-in-sync-with-a-local-version-part-one.html) covers it from a business-level perspective.*

I created a system for keeping a live version of a website in sync with a local one. I use a Ruby script activated by Cron to compare and sync the two versions and then get this out to everyone using the site by sharing a DropBox folder. A xml file, dubbed a Castlist, is used to compare last updated dates.

The Castlist File
-----------------

In order for the Ruby script to be able to compare assets in the live and local versions of the site, I used an XML file - here's an example:

	<?xml version="1.0" encoding="UTF-8"?>
	<castlist>
		<templates>
			<template id="223349" updated_at="2011-04-27 16:05:03.0" name="dmk_bottom" />
			<template id="224294" updated_at="2011-06-09 11:04:20.0" name="dmk_castlist" />
			... [ more templates ] ...
		</templates>
		<assets>
			<asset content_type="html" id="100466409" updated_at="2011-04-28 12:29:30.0" path="http://mediakit.skininc.com/index.html" />
			<asset content_type="html" id="102168174" updated_at="2010-11-04 08:45:03.0" path="http://mediakit.skininc.com/about/index.html" />
			<asset content_type="html" id="100467204" updated_at="2011-06-14 10:44:22.0" path="http://mediakit.skininc.com/advertising/index.html" />
			<asset content_type="css" id="020" updated_at="2007-07-07 02:00:00.0" path="http://s3.amazonaws.com/abm-assets/css/base.css" />
			<asset content_type="css" id="021" updated_at="2007-07-07 02:00:00.0" path="http://s3.amazonaws.com/abm-assets/css/si-brand-mini.css" />
			<asset content_type="js" id="026" updated_at="2007-07-07 02:00:00.0" path="http://s3.amazonaws.com/abm-assets/js/dmk/behavior.js" />
			... [ more assets ] ...
		</assets>
	</castlist>

There are two types of things I need to compare - templates and assets. Assets are the html, css and js files that make up the site, but the templates are a little more complicated. If I only had to compare the assets, then I actually wouldn't need the XML file at all, I could probably use the Last-Modified html header and be good to go.

The problem is that I don't want to rely on my CMS for anything, I want my solution to be independent from anything I haven't written. I can't write Java (its a Java-based platform) or anything fancy like that, but I can use their templating engine to report on the state of the templates themselves, so that's what I did. The Castlist file serves as the API of the CMS so that the script knows where things stand.

Ruby Gems Used
--------------

To write the Ruby script I used just two gems: [Nokogiri](https://github.com/tenderlove/nokogiri) and [Dropbox](https://github.com/RISCfuture/dropbox). Nokogiri to make parsing the XML castlist files easy and Dropbox to work with the [Dropbox API](https://www.dropbox.com/developers).

Script Overview
---------------

The main classes are `Comparer`, `Syncer` and `Fixer`. The overall flow of the script goes something like this: initialize a `Comparer` and a `Syncer` and see if there's a major change. A major change is something at the template level (like maybe something in navigation or a header image) that would require all pages to be refreshed. If not, then just look for stale or new pages.

Then the `Syncer` we initialized earlier makes a `Fixer` object and uploads fixed files through the DropBox API.

Finally, we use the `Comparer` to update the local Castlist as a record of what's been changed (so we don't do the same thing over and over).

The Comparer Method
-------------------

When the `Comparer` class is initialized it sets two instance variables called `live` and `local` to Nokogiri documents representing the live and local version of the Castlist files. These attributes are used by other instance methods to detect major changes, stale files and new files. The `major_change?` method is the first that's called and it looks like this:

	def major_change?
	  @live.root.css("template").detect do |live_node|
	    local_node = @local.root.css("template##{live_node.attributes['id']}").first
	    live_node.attributes['updated_at'].to_s != local_node.attributes['updated_at'].to_s
	  end
	end

So, we just iterate over the live Nokogiri document looking for templates that don't have matching `updated_at` dates. If one is found, then we have a major change and need to drop all the content and crawl the live site all over again. We use the `live\_urls` method for that:

	def live_urls
	  @live.root.css("asset").map { |node| node.attributes['path'].to_s }
	end

Not too much here, we're just finding all the assets in the live Castlist and then using `map` to convert them to a list of urls, which is what we'll be passing off to `Syncer` later.

But normally we wont have a major change, so then the next things to look for are stale files (files whose live version is newer than its local version) and new files that aren't in the local version. The `stale_urls` method looks like this:

	def stale_urls
	  stale_nodes = @live.root.css('asset').select do |live_node|
	    local_node = @local.root.css("asset##{live_node.attributes['id']}").first
	    if local_node
	      live_node.attributes['updated_at'].to_s != local_node.attributes['updated_at'].to_s
	    else
	      false
	    end
	  end
	
	  stale_nodes.map { |node| node.attributes['path'].to_s }
	end

We're iterating over the live Nokogiri document once again and as in `major\_change` we're interested in the difference between the live and local version `updated\_at` dates. The files where these don't match are thrown into `stale_nodes` which we then `map` to just the paths.

Last thing to check for are new urls, here's that method:

	def new_urls
	  new_nodes = @live.root.css('asset').select do |live_node|
	    @local.root.css("asset##{live_node.attributes['id']}").count == 0
	  end
	
	  new_nodes.map { |node| node.attributes['path'].to_s }
	end

Similar to the above methods: we're iterating over that same list of Nokogiri documents and once we find the elements we want, we use `map` to get just the paths of the files we're interested in. The only difference here is that we're using the result of the Nokogiri css method to decide if this file already exists. If not, then its picked.

So, these four methods are used to come up with an array of urls that need to be updated. In the case of a major change, this is really all of them and in the other cases, its just a subset of them.

The Syncer Method
-----------------

The `Syncer` class is what connects to DropBox through their API and actually does the uploading. Upon initialization, it creates a instance variable called `session` that uses `Dropbox::Session.deserialize` to reestablish the connection. Once connected, we wait for `Comparer` to feed us a list of urls and then the `upload_files` method gets to work:

	def upload_files(urls)
	  fixer = Fixer.new
	
	  urls.each do |url|
	    file_path, filename, extension = /com(.*\/)([\w\-]+\.(\w+))/.match(url).captures
	    clean_data = fixer.clean(url, extension)
	    upload_file(clean_data, @local_path + file_path, filename)
	  end
	
	  fixer.found_files.each do |url|
	    file_path, filename, extension = /com(.*\/)([\w\-]+\.(\w+))/.match(url).captures
	    clean_data = fixer.clean(url, extension)
	    upload_file(clean_data, @local_path + file_path, filename)
	  end
	end

I'll get into `Fixer` in the next section, but for now just know that it takes our data and spits it back out cleaned up. The other thing that Fixer does is look for more files that will need to be uploaded. This is important, so I'll go into that more now.

The Castlist is a manifest of sorts. Its a list of the assets that make up a website, but its not exhaustive and it shouldn't be. If we were limited to only those assets that appear in the Castlist, then every time a new image is needed, we'd need to add this to the Castlist. On a brochure website meant to sell ads, this would make running the site too slow. Further the people working on the content of the site are not programmers and know nothing about how CAST operates. All they know is how to edit pages in the CMS to make changes on the live websites.

And that's all they should care about. The Castlist is kept to just the elements of the site that are fairly stable. Things like the webpages and the css and js files that make it up. The exact elements on those pages can change without any affect on how CAST works. To support this, CAST must crawl the pages that make up the site and that's what `fixer.found_files` is all about.

The `upload_files` method is merely a controller here - it instantiates a `Fixer`, iterates over the urls it gets from the `Comparer` and the urls `Fixer` finds and then gets this content uploaded. The actual work happens in the `Fixer` class.

The Fixer Method
----------------

Since we can't rely on the Castlist to be a complete list of all assets on the site, we have to crawl pages and look for new things to download. But while we're crawling we should also change all absolute paths to relative ones. These are the two things the `Fixer` class does - we'll start with a method used to fix paths.

The path problem is pretty straightforward: on the live website, I make all paths absolute so that CAST can take the URL and retrieve the asset, but that's not going to work on the local copy where you don't have an internet connection, so the asset needs to be downloaded and the path needs to be altered to be relative. To do this I wrote the `find_relative_path` method:

	def find_relative_path(url)
	  steps = url.gsub(/http:\/\/mediakit.\w+.com\//, '').split('/').count - 1
	  '../' * steps
	end

We take the url of the file we're working with, remove the host and then count how many slashes we see. Subtract one from that number and use the juicy string multiplication we get in Ruby to return a string that's just a bunch of path changes. This is then used while we crawl.

When `Fixer` is instantiated it creates an instance variable called `found_files` that's going to be where we put assets we find while crawling. The crawling starts with the `clean` method:

	def clean(url, ext)
	  data = Net::HTTP.get URI.parse(url)
		
	  case ext
	  when 'css'
	    scan_for_images(data)
	  when 'html'
	    relative_path = self.find_relative_path(url)
	    data.gsub!(/(http:\/\/mediakit\.\w+\.com\/|https:\/\/s3\.amazonaws\.com\/)/, relative_path)
	    scan_for_files(data, relative_path)
	  end

	  return data
	end

The `clean` method is acting as a controller here - its job is to fetch the data using `url` and then call the right crawling method based on what type of file it is. Along the way we address paths using the relative path we found earlier.

Since our crawling is going to be slightly different depending on which type of file we're working with, we fork the code here using the file extension. For a file that's html, we use the `scan_for_files` method to crawl:

	def scan_for_files(data, relative_path)
	  while data =~ /(href|src)\=\"(http:\/\/media.\w+.com\/([\w\-\/\.]+))\"/ do
	    @found_files << $2 unless @found_files.include?($2)
	    data.sub!($2, relative_path + $3)
	  end
	end

The idea here is to find all nodes with a href or src attribute, add that attribute's value to our `found_files` array and then update the path using our relative path.

If we're working with a css file, then we use the `scan_for_images` method:

	def scan_for_images(data)
	  data.lines do |line|
	    if line =~ /url\(\"\.\.([\w\-\/\.]+)\"\)/
	      url = 'http://s3.amazonaws.com/abm-assets' + $1
	      @found_files << url unless @found_files.include?(url)
	    end
	  end
	end

As with the other scan method, we're looking for assets we don't already know about but in the CSS we're using relative paths already, so we just have to add them to the `found_files` array.

Deploying the Script
--------------------

While writing this script, I would just jump into Terminal and run it as I needed to check something, but once I was ready to actually start depending on this thing, I needed a way to run it on a schedule.

We happened to have a spare MacMini in the office that wasn't being used for anything important, so I commandeered it to serve as our CAST server. After a quick install of Git and RVM, I just cloned the repo, installed the couple Gem dependencies and got Ruby 1.9.2 installed.

For running the script on a schedule, I turned to my old frenemy Cron. I had never attempted something like this, so after some research (Googling), I found that I could run Bash commands as easily as anything else I've done with Cron and you could even run a series of commands by separating them with semicolons. Here's how I've got Cron running this script:

	0 * * * * /bin/bash -l -c 'rvm 1.9.2-p180@cast; cd /Users/jon/Projects/abm/cast/; ruby cast.rb > logs/result.log'

Every hour, on the hour with results logged to a log file that just keeps over-writing itself, all within the comfy confines of RVM with a suitable Gemset for this project. Easy in retrospect, but quite a pain to figure out at the time!

Fire and Forget
---------------

This project went through one re-write about a year in, but has mostly been a fire-and-forget type of project. I remote into the MacMini every once in a while to run Software Update, but other than that its very hands off.

*If you're interested in finding out more about the business-level strategy about this project, please read [Part One](/2011/08/08/keeping-a-live-website-in-sync-with-a-local-version-part-one.html).*

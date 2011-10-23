# To update, log into Google Reader and export list of feeds, then run script like this:
# $ ruby reader_converter.rb | pbcopy
#
# And then just paste into the <ul> in feeds/index.html

require 'rubygems'
require 'nokogiri'

def convert_to_li(node)
  "<li><a href=\"#{node.attr('xmlUrl')}\">#{node.attr('text')}</a></li>"
end

doc = Nokogiri::XML(File.open('google-reader-subscriptions.xml'))
feeds = doc.css('body outline outline')

feeds.each { |feed| puts convert_to_li(feed) }

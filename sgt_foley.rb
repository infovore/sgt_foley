#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
require 'yaml'
require 'json'

PATH_PREFIX = File.expand_path(File.dirname(__FILE__))

config = YAML.parse(File.read(PATH_PREFIX + "/creds.yml"))

%w{consumer_key consumer_secret access_token access_token_secret}.each do |key|
  Object.const_set(key.upcase, config["config"][key].value)
end

highestcount = File.read(PATH_PREFIX + "/highest").to_i

Twitter.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = ACCESS_TOKEN
  config.oauth_token_secret = ACCESS_TOKEN_SECRET
end

# there are more, but this is a start.
FOLEY_LINES = ["Ramirez! use your smoke grenades!",
               "Ramirez! come to the alley!",
               "Ramirez! cover me!",
               "Ramirez! cover me!",
               "Ramirez! we're at the crash site! Get over here!",
               "Ramirez! get to the roof and check out the supply drop.",
               "Ramirez! get the fuck off the roof!",
               "Ramirez! take your team and secure the Burger Town!",
               "Ramirez, we got hostile!",
               "Ramirez, use the remote controlled Predator Missiles!",
               "Ramirez, hostiles, right next to the restaurant.",
               "Ramirez, I'm moving!",
               "Ramirez, contact at your nine o'clock.",
               "Ramirez! The convoy is just to the south of Burger Town, get your ass over here!",
               "Ramirez! We gotta get back to the convoy! Let's go!",
               "Ramirez! You're gonna get run over, get out of the way!",
               "Ramirez! Honey Badger's moving.",
               "Ramirez! Use your laser designator to call in artillery on those vehicles.",
               "Ramirez, get that briefcase - what's left of it.",
               "Ramirez! Move up and stay out of that LAV's line of fire.",
               "Ramirez! Hostiles taking cover behind those stacked-up ammo crates!",
               "Ramirez! Scan for targets to the south of the Washington Monument!",
               "Ramirez, use some of this ordnance to take out the enemy vehicles!",
               "Ramirez! Last mag, make it count!",
               "Ramirez, take point.",
               "Ramirez, let's go!",
               "Ramirez! Do Everything!"]

client = Twitter::Client.new
search = Twitter::Search.new

search.containing("Ramirez").not_from("foleybot").since_id(highestcount).each do |r|
  random_line = FOLEY_LINES.sort_by {rand}.first
  string = "@#{r.from_user} #{random_line}"
  client.update(string, :in_reply_to_status_id => r.id)
  if r.id.to_i > highestcount
    highestcount = r.id.to_i
  end
end

File.open(PATH_PREFIX + "/highest", "w") {|f| f.write(highestcount.to_s)}

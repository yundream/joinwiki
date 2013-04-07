#!/usr/bin/ruby
require 'json'
require 'pp'

aFile = File.new("list.json","r")
contents = aFile.sysread(aFile.stat.size)
flist = JSON.parse(contents)
pp flist


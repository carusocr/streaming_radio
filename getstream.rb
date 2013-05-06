#!/usr/bin/env ruby

require 'nokogiri'

sources = Hash.new
doc = Nokogiri::XML(File.open("getstream.xml"))
doc.xpath('//SrcDef').each do |node|
	sources[:src] = node.xpath('Src').text
	sources[:url] = node.xpath('Url').text
#	puts sources[:src], sources[:url]
end

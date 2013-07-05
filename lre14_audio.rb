#!/usr/bin/env ruby

require 'nokogiri'

src_dir="/lre14/bin/streaming"
src_dir="."
config_file = "getstream.xml"
sources = Hash.new
doc = Nokogiri::XML(File.open("#{src_dir}/#{config_file}"))
doc.xpath('//SrcDef/Dialect').each do |node|
	srcinfo = node.xpath('parent::node()').text.split("\n")
	srcinfo.map{|x| x.strip!}
	sources["#{node.xpath('../@id')}"] = (srcinfo.reject{|x| x.length == 0})
end

sources.keys.each do |s|
	src_country = 
	puts sources[s][0], sources[s][1], sources[s][2], sources[s][3]
end

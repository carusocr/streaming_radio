#!/usr/bin/env ruby

require 'nokogiri'

doc = Nokogiri::XML(File.open("getstream.xml"))
doc.collect_namespaces
#puts doc
doc.xpath('//SrcTbl/SrcDef').each do |node|
	#puts node.xpath('Src')
end
stream = doc.xpath('//Src'=> 'freqvence')
puts stream

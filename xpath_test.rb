#!/usr/bin/env ruby

require 'nokogiri' 

config_file = 'placemark.xml'

doc = Nokogiri::XML(File.open(config_file))
found_count = doc.xpath('//Placemark/Name[contains(.,"por") and contains(.,"que")]').count
puts found_count
#doc.xpath('//Placemark/Name[contains(.,"por") and contains(.,"que")]').each do |n|
#	puts n.text
#	puts n.parent.xpath('./Src').text
#end

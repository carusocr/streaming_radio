#!/usr/bin/env ruby

=begin

Script to read in list of streaming radio sources from xml file, 
use mplayer to download approximately 30 minutes of each source
to a uniquely-named output file.

=end

require 'nokogiri'
require 'time'

abort "You must enter an iso639 language code!" unless ARGV[0]
src_dir = "/lre14/bin/streaming"
config_file = "getstream_#{ARGV[0]}.xml"
su_name = 'walkerk'
MPLAYER = '/usr/bin/mplayer'
RECDIR = '/mnt/drobo/12/streaming';
REC_DURATION = 1700;
sources = Hash.new
doc = Nokogiri::XML(File.open("#{src_dir}/#{config_file}"))
doc.xpath('//SrcDef').each do |node|
	node.xpath('./@id')
	srcinfo = node.xpath('child::node()').text.split("\n")
	srcinfo.map{|x| x.strip!}
	sources["#{node.xpath('./@id')}"] = (srcinfo.reject{|x| x.length==0})
end
sources.keys.each do |s|
	src_name = sources[s][0]
	src_url = sources[s][1]
	src_lang = sources[s][2]
	timestring = Time.now.strftime("%Y%m%d_%H%M%S")
	cmd = "#{MPLAYER} #{src_url} -cache 8192 -dumpstream -dumpfile #{timestring}_#{src_name}_#{src_lang}.mp3\n"
	puts cmd
end

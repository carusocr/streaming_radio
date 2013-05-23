#!/usr/bin/env ruby
#Streaming radio capture script
#Author: Chris Caruso
# May 2013

=begin

Script to read in list of streaming radio sources from xml file, 
use mplayer to download approximately 30 minutes of each source
to a uniquely-named output file.

=end

require 'nokogiri'
require 'time'

abort "You must enter an iso639 language code!" unless ARGV[0]
src_dir = "/lre14/bin/streaming"
src_dir = "."
config_file = "getstream_#{ARGV[0]}.xml"
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

def download_stream(src_name,src_url,src_lang)
	puts src_url, src_name, src_lang
end

def killprocs(src_name) # <--- change this to src_url after testing! ***
	targets = (`ps -fC vim | grep '#{src_name}' | awk '{print $2}'`).split
	targets.each do |t|
		puts "Killing process #{t}...\n"	
	end
end

# Loop over set of sources, check to make sure that 
# no other download processes for that source are running,
# kick off new process.

sources.keys.each do |s|

	src_name = sources[s][0]
	src_url = sources[s][1]
	src_lang = sources[s][2]
	killprocs(src_name) # Kill any existing downloads.
	timestring = Time.now.strftime("%Y%m%d_%H%M%S")
	cmd = "#{MPLAYER} #{src_url} -cache 8192 -dumpstream -dumpfile #{timestring}_#{src_name}_#{src_lang}.mp3\n"
	#fork each source download and record PID in hash
	src_pid = Process.fork {download_stream(src_name,src_url,src_lang)}
	sources[s][3] = src_pid
	puts "Source PID is #{src_pid} for #{src_name} download process.\n"
	#download_stream(src_name,src_url,src_lang)

end
sources.keys.each do |s|
	puts sources[s][3]
end


#!/usr/bin/env ruby

=begin

How I understand the Perl script to work:

1. Source hash initialized.
2. Output hash initialized.
3. Specific source passed via command line argument
4. Output file variable set up via constants and output hash.
5. clvc argument array joined in with cvlc inside eval statement:
		   my $ccc = sprintf("%s -l %s -c %s%s%s 2>&1 >%s",
          SU, SU_NAME,'"', join(' ',CVLC,@cvlc_args), '"', "/dev/null" );
6. Once clvc command is set:
			my $vlcpid = fork();
			if ($vldpic==0){ exec($ccc)};
=end

require 'nokogiri'

sources = Hash.new
doc = Nokogiri::XML(File.open("getstream.xml"))
#doc.xpath('//SrcDef').each do |node|
#doc.xpath('//SrcDef').children.each do |node|
#	puts node.methods
#	sources[:src] = node.xpath('Src').text
#	sources[:url] = node.xpath('Url').text
#	puts sources[:src], sources[:url]
#end

sources = doc.xpath('//SrcDef/child::node()').text.split("\n")
#puts doc.xpath('//SrcDef/child::node()').text
puts sources[2]

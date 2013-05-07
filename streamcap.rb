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
doc.xpath('//SrcDef').each do |node|
	node.xpath('./@id')
	srcinfo = node.xpath('child::node()').text.split("\n")
	sources["#{node.xpath('./@id')}"] = (srcinfo.reject{|x| x.strip.length==0})
end
sources.keys.each do |s|
	puts sources[s][2]
end

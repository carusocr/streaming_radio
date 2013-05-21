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
require 'time'

SRC_CONFIG = '/lre14/bin/streaming/getstream.xml'
SU = '/bin/su'
SU_NAME = 'walkerk'
CVLC = '/usr/bin/cvlc'
MPLAYER = '/usr/bin/mplayer'
RECDIR = '/mnt/drobo/12/streaming';
REC_DURATION = 1700;
sources = Hash.new
doc = Nokogiri::XML(File.open(SRC_CONFIG))
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
	src_port = sources[s][3]
	timestring = Time.now.strftime("%Y%m%d_%H%M%S")
	cmd = "#{MPLAYER} #{src_url} -cache 8192 -dumpstream -dumpfile #{timestring}_#{src_name}_#{src_lang}.mp3\n"
#	cmd = "#{SU} -l #{SU_NAME} -c \"#{CVLC} --http-caching 3000 --codec ffmpeg #{src_url} --sout \" 2>&1 > /dev/null\n"
	puts cmd
end

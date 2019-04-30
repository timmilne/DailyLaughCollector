#!/user/bin/perl
#
# $Header:$
#
# dlc - Daily Laugh Collector: extract several comics and send it to web 
#  	browser.
# 	You can use an optional date, but the default is today.
# 	If you put in a negative number, dlc rewinds back that many days
# 	and displays all days up to today:
# 	  -1 = yesterday
# 	  -3 = 3 days ago
#
# Usage: dlc [date]
#
# TPM 1/29/15
#
# Mac OS X version - but includes code that should enable it on all platforms
#
# TPM 6/1/18
#
# NOTE: This uses the LWP::UserAgent::Determined perl module available from
#       CPAN.  LWP is preinstalled on the Mac, so you may not need to install
#	this.  If so:
#
#          sudo cpan LWP::UserAgent::Determined
#
#	Selected the local::lib option, which put the modules in ~/perl5
#	and bootstraps to there.
#	Added the following to ~/.bashrc
#
#	   PERL_MB_OPT="--install_base \"/Users/z018620/perl5\""; export PERL_MB_OPT;
#	   PERL_MM_OPT="INSTALL_BASE=/Users/z018620/perl5"; export PERL_MM_OPT;
#	   [ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
#
#	And then all that was missing was Shell...
#
# TPM 4/30/19
#
# NOTE: UserAgent::Determined is preinstalled, but Mac OSX now needs a Mozilla package.
#	Here's how to do it:
#
#	http://triopter.com/archive/how-to-install-perl-modules-on-mac-os-x-in-4-easy-steps/
#
#	I only had to do steps 1.5, 3, and 4
#
#	1.5 - Install Command Line Tools (Recent XCode)
#
#       	Done as part of the XCode setup from Self Service
#
#	3 - Upgrade CPAN
#
#       	Before beggining, I disconnected from Cisco AnyConnect before doing this to
#		have direct access to mirror sites
#
#	        $ sudo perl -MCPAN -e 'install Bundle::CPAN'
#
#	        Accepted all defaults and chose local::lib when prompted
#
#	        Takes a while to download and compile everything
#
#	5 - Install your modules
#		
#		$ sudo perl -MCPAN -e 'install Mozilla::CA'
#

use strict;
use POSIX qw(strftime);
use LWP::UserAgent::Determined;

# Set the platform specific browser command
my $platform = $^O;
my $browserCmd;
if    ($platform eq 'darwin')  { $browserCmd = "open";          } # Mac OS X
elsif ($platform eq 'linux')   { $browserCmd = "x-www-browser"; } # Linux
elsif ($platform eq 'MSWin32') { $browserCmd = "start";         } # Win95..Win7
else {
  die "Can't locate default browser";
}

# Open a new window for this
# Having problems if no window open, so open one first...
system("$browserCmd \"http://itgt.target.com\"");

# Get how many days to fetch
my $numDays = (scalar(@ARGV)>0 && $ARGV[0] < 0)?($ARGV[0]):0;

# Do this for the desired number of days.
for (my $curDay = $numDays; $curDay <= 0; $curDay++)
{

# Open the processing files
my $tmpfile = "tmp.html";
my $htmlfile = "html$curDay.html\n";
open (OUT, ">$htmlfile") || die "Can't open: $htmlfile";

# Set the date (with optional arguments)
my $date = (scalar(@ARGV)>0 && $ARGV[0] < 0)?
	strftime "%Y%m%d", localtime((time + $curDay*86400)):
	(scalar(@ARGV)>0)?$ARGV[0]:strftime "%Y%m%d", localtime;
# The new Dilbert website requires some adaptations
my $altDate = (scalar(@ARGV)>0 && $ARGV[0] < 0)?
	strftime "%Y-%m-%d", localtime((time + $curDay*86400)):
	(scalar(@ARGV)>0)?$ARGV[0]:strftime "%Y-%m-%d", localtime;

# Other variables
my $imageName;
my $browser = LWP::UserAgent::Determined->new;
my $response;

# Begin the OUT file
print OUT "<HTML><body>";

################################################################################
# Dilbert Version 3.0 (to fix the new reformat)
################################################################################
print OUT "<strong><font face=\"arial\">Dilbert</strong><br>";

# Grab the website
my $url = "http:\/\/dilbert.com\/strip\/".$altDate;

print "Getting Dilbert...\n";
# TPM This worked pretty slick, sending the response straight to a content file
# Alas, the bug remained, and the response is truncated...
#$response = $browser->get($url);
$response = $browser->get($url,":content_file"=>$tmpfile);
die $response->error_as_HTML if (!$response->is_success);

# Reopen the file for reading
open (IN, "$tmpfile") || die "Can't open: $tmpfile";

while (<IN>)
{
  # Is this a line we are interested in?
  next if (!/amuniversal/);

  # Strip off the beginnings and endings
  s/^.*http/http/;
  s/\".*//;

  #Save the url
  $url = $_;
  last;
}

# Append to the target file
print OUT "<img src=\"$url\"><p>\n";

# TPM If the file parse didn't work, just open the original url in it's own tab
#system("$browserCmd $url");

################################################################################
# Calvin and Hobbes
################################################################################
print OUT "<strong><font face=\"arial\">Calvin and Hobbes</strong><br>";

my $day = substr($date,6);
my $month = substr($date,4,2);
my $year = substr($date,0,4);

# Grab the website
my $url = "http:\/\/www.gocomics.com\/calvinandhobbes\/".$year."\/".$month."\/".$day;

print "Getting Calvin and Hobbes...\n";
# TPM This worked pretty slick, sending the response straight to a content file
# Alas, the bug remained, and the response is truncated...
#$response = $browser->get($url);
$response = $browser->get($url,":content_file"=>$tmpfile);
die $response->error_as_HTML if (!$response->is_success);

# Reopen the file for reading
open (IN, "$tmpfile") || die "Can't open: $tmpfile";

while (<IN>)
{
  # Is this a line we are interested in?
  next if (!/assets.amuniversal/);

  # Strip off the beginnings and endings
  s/^.*http/http/;
  s/\".*//;

  #Save the url
  $url = $_;
  last;
}

# Append to the target file
print OUT "<img src=\"$url\"><p>\n";

# Old way (breaks on Sunday)
#my $day = substr($date,2);
#my $year = substr($date,0,4);

#print "Getting Calvin and Hobbes...\n";
#$url = "http:\/\/images.ucomics.com\/comics\/ch\/$year\/ch$day.gif";

# Append to the target file
#print OUT "<img src=\"$url\"><p>\n";

################################################################################
# Garfield
################################################################################
print OUT "<strong><font face=\"arial\">Garfield</strong><br>";

my $day = substr($date,6);
my $month = substr($date,4,2);
my $year = substr($date,0,4);

# Grab the website
my $url = "http:\/\/www.gocomics.com\/garfield\/".$year."\/".$month."\/".$day;

print "Getting Garfield...\n";
# TPM This worked pretty slick, sending the response straight to a content file
# Alas, the bug remained, and the response is truncated...
#$response = $browser->get($url);
$response = $browser->get($url,":content_file"=>$tmpfile);
die $response->error_as_HTML if (!$response->is_success);

# Reopen the file for reading
open (IN, "$tmpfile") || die "Can't open: $tmpfile";

while (<IN>)
{
  # Is this a line we are interested in?
  next if (!/assets.amuniversal/);

  # Strip off the beginnings and endings
  s/^.*http/http/;
  s/\".*//;

  #Save the url
  $url = $_;
  last;
}

# Append to the target file
print OUT "<img src=\"$url\"><p>\n";

# Old way (breaks on Sunday)
#my $day = substr($date,2);
#my $year = substr($date,0,4);

#print "Getting Garfield...\n";
#$url = "http:\/\/images.ucomics.com\/comics\/ga\/$year\/ga$day.gif";

# Append to the target file
#print OUT "<img src=\"$url\"><p>\n";

################################################################################
# User Friendly
################################################################################
#print OUT "<strong><font face=\"arial\">User Friendly</strong><br>";

# Grab the web page
#$url = "http://ars.userfriendly.org/cartoons/?id=$date";

#print "Getting User Friendly...\n";
# TPM This worked pretty slick, sending the response straight to a content file
# Alas, the bug remained, and the response is truncated...
#$response = $browser->get($url);
#$response = $browser->get($url,":content_file"=>$tmpfile);
#die $response->error_as_HTML if (!$response->is_success);

# Reopen the file for reading
#open (IN, "$tmpfile") || die "Can't open: $tmpfile";

#while (<IN>)
#{
  # Is this a line we are interested in?
  #next if (!/<a href="\/cartoons/);

  # Strip off the beginnings and endings
  #s/^.*src="//;
  #s/gif.*/gif/;

  # Save the url
  #$url = $_;
  #last;
#}

# Append to the target file
#print OUT "<img src=\"$url\"><p>\n";

################################################################################
# xkcd
################################################################################
#print OUT "<strong><font face=\"arial\">xkcd</strong><br>";

##Grab the web page
#open (OUTTMP, ">$tmpfile") || die "Can't open: $tmpfile";
#$url = "http://www.xkcd.com";

##Get the image number
#if (scalar(@ARGV)>0 && $ARGV[0] < 0)
#{
#my $imageNumber = $ARGV[0];
#
##Grab the web page
#$response = $browser->get($url);
#print "Getting xkcd...\n";
#die $response->error_as_HTML if (!$response->is_success);
#print OUTTMP $response->content;
#close(OUTTMP);
#
##Reopen the file for reading
#open (IN, "$tmpfile") || die "Can't open: $tmpfile";
#
#while (<IN>)
#{
##Is this a line we are interested in?
#next if (!/Permanent link to this comic/);
#
##Strip off the beginnings and endings
#s/^.*\.com\///;
#s/\/<\/h3>.*//;
#
##Get the current image number
#$imageNumber = $_;
#last;
#}
#
##Adjust the image number
#$imageNumber += $ARGV[0];
#$url = "http://www.xkcd.com/".$imageNumber;
#open (OUTTMP, ">$tmpfile") || die "Can't open: $tmpfile";
#}

#Grab the specific web page
#$response = $browser->get($url);
#die $response->error_as_HTML if (!$response->is_success);
#print OUTTMP $response->content;
#close(OUTTMP);

##Reopen the file for reading
#open (IN, "$tmpfile") || die "Can't open: $tmpfile";

#while (<IN>)
#{
##Is this a line we are interested in?
#next if (!/Image URL \(for hotlinking/);
#
##Strip off the beginnings and endings
#s/^.*: //;
#s/png.*/png/;
#
##Save only the image name
#$imageName = $_;
#last;
#}

#Rebuild the image url
#$url  = $imageName;
#chop $url;

#Append to the target file
#print OUT "<img src=\"$url\"><p>";

# Close OUT
print OUT "</body>";
close(OUT);

# Send it to a browser
system("$browserCmd $htmlfile");

# Pauses no longer needed
#sleep(1);
}

# Check Woot, BeDeal and slickdeals...
system("$browserCmd http://woot.com");
#sleep(3);
system("$browserCmd http://www.slickdeals.net");
#sleep(3)
system("$browserCmd http://www.facebook.com");
#sleep(3);
system("$browserCmd http://my.yahoo.com");
#sleep(3);
system("$browserCmd http://www.msn.com");

#
# $Log:$
#
#
# EOF

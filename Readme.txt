TPM 6/1/18

Yes, I've been running this script for over 14 years.  But Mac OSX just broke
it, and I need to install the Mozilla::CA package.  Here's a way to do it
with CPAN:

	http://triopter.com/archive/how-to-install-perl-modules-on-mac-os-x-in-4-easy-steps/

Note: I only had to do steps 1.5, 3, and 4, and for 4 I ran:

	$ sudo perl -MCPAN -e 'install Mozilla::CA'

And whala!  That fixed my problem!!  dlc lives on!!!


TPM 4/30/19

Now 15 years!!

Setting up my new mac, I needed to do all this again.  As before I skipped the other setup steps and did 1.5, 3 and 4

	http://triopter.com/archive/how-to-install-perl-modules-on-mac-os-x-in-4-easy-steps/

1.5 - Install Command Line Tools (Recent XCode)

	Done as part of the XCode setup from Self Service

3 - Upgrade CPAN

	Before beggining, I disconnected from Cisco AnyConnect before doing this to have direct access to mirror sites

	$ sudo perl -MCPAN -e 'install Bundle::CPAN'

	Accepted all defaults and chose local::lib when prompted

	Takes a while to download and compile everything

5 - Install your modules

	$ sudo perl -MCPAN -e 'install Mozilla::CA'


Back in business!!


TPM 3/16/23

18 years, and woke bombed.

Well, it seems Adams has finally gone too far and was cancelled by the woke mob.  His distributor, GoComics, dropped
him, and now my script won't pull him any more.  To make matters worse, Target's woke web filter is blocking the
replacement.  So stupid.  Corporate thought police.  Time for a rewrite.

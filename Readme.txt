TPM 6/1/18

Yes, I've been running this script for over 14 years.  But Mac OSX just broke
it, and I need to install the Mozilla::CA package.  Here's a way to do it
with CPAN:

http://triopter.com/archive/how-to-install-perl-modules-on-mac-os-x-in-4-easy-steps/

Note: I only had to do steps 1.5, 3, and 4, and for 4 I ran:

$ sudo perl -MCPAN -e 'install Mozilla::CA'

And whala!  That fixed my problem!!  dlc lives on!!!

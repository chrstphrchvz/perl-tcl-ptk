# slide.pl


use Tcl::pTk;
use Tcl::pTk::LabEntry;
use Tcl::pTk::Facelift;
use Test;
use strict;

plan tests => 1;



my $top = MainWindow->new();

my $entry = "data here";

my $LabEntry = $top->LabEntry(
    -textvariable => \$entry,
    -label => 'Bogus',
    -labelFont=>"Courier 12", # Additional options for testing full functionality
    -labelForeground=>'blue',
    -labelPack => [-side => 'left']);

$LabEntry->pack(-side => 'top', -pady => 2, -anchor => 'w', -fill => 'x', -expand => 1);


$top->after(100,sub{$top->destroy}) unless(@ARGV); # go away, unless something on command line (debug mode)

MainLoop;


ok(1, 1, "LabEntry Facelift Widget Creation");



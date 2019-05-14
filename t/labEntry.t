# slide.pl

use warnings;
use strict;

use Tcl::pTk;
use Tcl::pTk::LabEntry;
use Test;

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


# Update text by updating variable
$top->update;
$entry = "More Data Here";
$top->update;

MainLoop if (@ARGV);


ok(1, 1, "LabEntry Widget Creation");



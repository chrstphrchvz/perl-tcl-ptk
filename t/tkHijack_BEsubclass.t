# This is a empty subclass test of the BrowseEntry widget with TkHijack and TkFacelift

use warnings;
use strict;

use Test;

use Tcl::pTk::TkHijack;
use Tcl::pTk::Facelift;

############# Empty subclass test ####################

package Tk::Browse2;


use base qw/Tk::BrowseEntry/;


Construct Tk::Widget 'Browse2';


1;

############################################################


package main;


use Tk;


$| = 1;

my $top = MainWindow->new();

# This will skip if Tile widgets not available
unless ($Tcl::pTk::_Tile_available) {
    print "1..0 # Skipped: Tile unavailable\n";
    $top->destroy;
    exit;
}
 
plan tests => 2;

my $option;


my $be = $top->BrowseEntry(-variable => \$option )->pack(-side => 'right');
$be->insert('end',qw(one two three four));

#print "be = ".ref($be)."\n";

$be->pack(-side => 'top', -fill => 'x', -expand => 1);
my @components0 = $be->children();
#print "'".join("', '", @components0)."'\n";


# A Face-lifted browseentry should have only 1 component
ok(scalar(@components0), 1, "Facelifted BrowseEntry Components = 1");



my $be2 = $top->Browse2(-variable => \$option )->pack(-side => 'right');
$be2->insert('end',qw(one two three four));

#print "be2 = ".ref($be2)."\n";
my @components = $be2->children();
#print join(", ", @components)."\n";

# A Face-lifted browseentry-subclass should also have only 2 components
ok(scalar(@components), 1, "Facelifted BrowseEntry Subclass Components = 1");

$be2->pack(-side => 'top', -fill => 'x', -expand => 1);


(@ARGV) ? MainLoop : $top->destroy; # For debugging only, enter the mainloop if args supplied on the command line

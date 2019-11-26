#  Simple use of Tcl::pTk::TkHijack and TkFacelift with a subclassed Frame

use warnings;
use strict;
use Tcl::pTk::TkHijack;
use Tcl::pTk::Facelift;

use Tk;

use Test;




############# Empty Frame subclass test ####################

package Tk::Frame2;


use base qw/Tk::Frame/;


Construct Tk::Widget 'Frame2';


1;
package main;
##########################################################

#@Tk::Frame2::ISA = ('Tcl::pTk::FramettkSubs');

my $top = MainWindow->new( -title => "Hijack Test" );

# This will skip if Tile widgets not available
unless ($Tcl::pTk::_Tile_available) {
    print "1..0 # Skipped: Tile unavailable\n";
    exit;
}
 
plan tests => 1;


my $frame0 = $top->Frame();

my $frame = $top->Frame2()->pack();
$frame->configure(-bd=> 1);

# Frame2 should be a subclass of FramettkSubs when Tcl::pTk::TkFacelift is present
ok(join(", ", @Tk::Frame2::ISA), "Tcl::pTk::FramettkSubs");



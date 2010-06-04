#!/usr/bin/perl -w
#
#
#  Simple use of Tcl::pTk::TkHijack and TkFacelift with a subclassed Frame

use Tcl::pTk::TkHijack;
use Tcl::pTk::TkFacelift;

use Tk;

use Test;
plan tests => 1;





############# Empty Frame subclass test ####################

package Tk::Frame2;


use base qw/Tk::Frame/;


Construct Tk::Widget 'Frame2';


1;
package main;
##########################################################

#@Tk::Frame2::ISA = ('Tcl::pTk::FramettkSubs');

my $top = MainWindow->new( -title => "Hijack Test" );

my $frame0 = $top->Frame();

my $frame = $top->Frame2()->pack();
$frame->configure(-bd=> 1);

# Frame2 should be a subclass of FramettkSubs when Tcl::pTk::TkFacelift is present
ok(join(", ", @Tk::Frame2::ISA), "Tcl::pTk::FramettkSubs");



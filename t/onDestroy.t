# Check of OnDestroy operation

use warnings;
use strict;

use Tcl::pTk;
#use Tk;

use Test;

plan tests => 1;

my $top = MainWindow->new;

my $DestroyCalled = 0;

my $menubar = $top->Frame(qw/-relief raised -background DarkGreen -bd 2/);
$menubar->pack(-side => 'top', -fill => 'x');

#$menubar->bind('<Destroy>', sub{ print STDERR "Frame Destroyed\n"});

$menubar->OnDestroy(
                sub{ 
                #print STDERR "Frame Destroyed\n";
                $DestroyCalled = 1;
                });

$top->idletasks;
(@ARGV) ? MainLoop : $top->destroy;

ok($DestroyCalled, 1, 'Destroy Callback not called');




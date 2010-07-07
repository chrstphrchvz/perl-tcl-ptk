# This test checks to see if image loading and usage (in this case the 'folder' images used
# in the DirTree Widget) works across interpreters.

use Test;

plan tests =>  1;
use Tcl::pTk;
use Tcl::pTk::DirTree;
my $top = MainWindow->new;
#my $dl  = $top->Scrolled('DirTree')->pack(-expand => 1 , -fill => 'both');
my $dl  = $top->DirTree->pack(-expand => 1 , -fill => 'both');
$top->after(1000, sub{ $top->destroy});

MainLoop;

$top = MainWindow->new;
$dl  = $top->DirTree->pack(-expand => 1 , -fill => 'both');
$top->after(1000, sub{ $top->destroy});
MainLoop;

ok(1);  # If we got this far, the test passed

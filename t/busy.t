# Test of Busy / UnBusy operation
use warnings;
use strict;
use Tcl::pTk;
#use Tk;
use Test;
plan tests => 1;

my $mw = MainWindow->new;

$mw->Label(-text => "Label1")->pack;
$mw->Label(-text => "Label2")->pack;
$mw->Button(-text => "Label3")->pack;
$mw->Entry(-text => "Label4")->pack;

$mw->update;
$mw->Busy;
$mw->update;
$mw->update;
$mw->Unbusy;

$mw->update;
MainLoop if (@ARGV);
			
ok(1, 1, "Busy");


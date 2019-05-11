
# This test case checks for a specific problem found using TableMatrix::Spreadsheet and TkHijack
#   Before this bug was fixed, the TableMatrix module would get loaded twice, causing problems

use warnings;
use strict;

use Tcl::pTk::TkHijack;

use Test;

use Tk;

use Tk::TableMatrix;
use Tk::TableMatrix::Spreadsheet;

my $top = new MainWindow;

# This will skip if Tktable not present
my $retVal = $top->interp->pkg_require('Tktable');

unless( $retVal){
    print "1..0 # Skipped: Tktable Tcl package not available\n";
	$top->destroy;
    exit;
}

plan tests => 1;

my $arrayVar = {};

foreach my $row  (0..20){
	foreach my $col (0..10){
		$arrayVar->{"$row,$col"} = "r$row, c$col";
	}
}

$| = 1;

my $t = $top->Scrolled('Spreadsheet', -rows => 21, -cols => 11, 
                              -width => 6, -height => 6,
			      -titlerows => 1, -titlecols => 1,
			      -variable => $arrayVar,
			      -selectmode => 'extended',
			     #  -state => 'disabled'
                    );
$t->pack(-expand => 1, -fill => 'both');

$top->idletasks;
MainLoop if (@ARGV); # auto-quit unless commands supplied (for debugging)

ok(1,1,"Hijack Test");

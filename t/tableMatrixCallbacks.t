#!/usr/local/bin/perl -w

# Tablematrix prototype support in Tcl/Tk
#   This includes the Variable Tracing that works with large arrays, without causing
#   performance issues.
#   

use Tcl::Tk qw/:perlTk/;
use Tcl::Tk::Widget::TableMatrix;
use Test;

plan test => 4;

use Data::Dumper;

$| = 1; # Pipes Hot
my $top = MainWindow->new;

# This will skip if Tktable not present
my $retVal = $top->interp->pkg_require('Tktable');

unless( $retVal){
        skip("Tktable Tcl package not available", 1);
        exit;
}


my $arrayVar = {};

#print "Filling Array...\n";
my ($rows,$cols) = (20, 10);
foreach my $row  (0..($rows-1)){
	foreach my $col (0..($cols-1)){
		$arrayVar->{"$row,$col"} = "$row,$col";
	}
}

my $label = $top->Label(-text => "TableMatrix v2 Example");
my $t = $top->Scrolled('TableMatrix', -rows => $rows, -cols => $cols, 
#        my $t = $toplevel->TableMatrix( -rows => $rows, -cols => $cols, 
                                      -width => 6, -height => 6,
                                       -titlerows => 1, -titlecols => 1,
                                      -variable => $arrayVar,
                                      -coltagcommand => \&colSub,
                                      -colstretchmode => 'last',
                                      -rowstretchmode => 'last',
                                      -selectmode => 'extended',
                                      -selecttitles => 0,
                                      -drawmode => 'slow',
                            );


# Create browsecmd callback
my ($prevIndex, $currentIndex) = ('', '');
$t->configure(-browsecmd => sub{
         ($prevIndex, $currentIndex) = @_;
         
         #print "prevIndex = $prevIndex currentIndex = $currentIndex\n";
});

# Setup test for browsecmd callback
$top->after(1000, sub{
                $t->activate('2,2');
                ok($prevIndex, '',    "browsecmd previndex 1");
                ok($currentIndex, '2,2', "browsecmd currentIndex 1");
});

# Setup test for browsecmd callback
$top->after(2000, sub{
                $t->activate('2,3');
                ok($prevIndex, '2,2',    "browsecmd previndex 2");
                ok($currentIndex, '2,3', "browsecmd currentIndex 2");
});

$t->pack();


$top->after(3000, sub{
                $top->destroy;
}) unless(@ARGV); # if args supplied, don't exit right away (for debugging)
 

MainLoop;


        


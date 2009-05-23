# entry1.pl

use strict;
use Test;
use Tcl::Tk qw/:perlTk :eventtypes /;  # import eventtypes, because we are going to check to see if DoOneEvent works


plan tests => 3;

my $textVar = "Initial Value";

my $TOP = MainWindow->new();

    my(@relief) = qw/-relief sunken/;
    my(@pl) = qw/-side top -padx 10 -pady 5 -fill x -expand 1/;
    my $e1 = $TOP->Entry(@relief, -textvariable => \$textVar)->pack(@pl);
    my $e2 = $TOP->Entry(@relief)->pack(@pl);
    my $e3 = $TOP->Entry(@relief)->pack(@pl);

    $e2->insert('end', 'This entry contains a long value, much too long to fit in the window at one time, so long in fact that you\'ll have to scan or scroll to see the end.');

    my $selectPresent = $e2->selectionPresent;
    ok($selectPresent, 0, "camelCase call check");
    
$TOP->after(1000,sub{$TOP->destroy});

ok(1, 1, "Entry Widget Creation");

# Check to see if the textvariable is returned properly as a scalar reference
my $scalarRef = $e1->cget(-textvariable);
ok(ref($scalarRef), 'SCALAR', "textvariable is scalar ref");

# Make sure DoOneEvent call works
DoOneEvent(DONT_WAIT);

# Make sure timeofday works
my $t = Tcl::Tk::timeofday;


MainLoop;

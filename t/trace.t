use warnings;
use strict;

use Tcl::pTk;

use Test;
$| = 1;

plan tests => 5;

my $TOP = MainWindow->new();

my $perlscalar;
my $updateSubVar;

my $e1 = $TOP->Entry( -textvariable => \$perlscalar)->pack();

$TOP->traceVariable( \$perlscalar, 'wr' => \&update_sub );

# Testing of reading the perl variable (should trigger a read from Tcl)
$TOP->update;
$e1->insert("end", "new value");

$TOP->update;
ok( $perlscalar,   "new value", "variable tie from tcl to perl");
ok( $updateSubVar, "new value", "variable tie from tcl to perl");


$TOP->update;
$perlscalar = "new value2";

$TOP->update;
ok( $e1->get,      "new value2", "variable tie from perl to tcl");
ok( $updateSubVar, "new value2", "variable tie from perl to tcl");

# Cancel Tracing
$TOP->update;
$TOP->traceVdelete(\$perlscalar);
$e1->insert("end", "321");
ok( $perlscalar,   "new value2321", "variable tie from tcl to perl after traceVdelete");

$TOP->update;
MainLoop if (@ARGV);

#print "perlscalar = $perlscalar\n";

#my $obj = tied $perlscalar;

#print "obj = $obj\n";


sub update_sub {
     my( $index, $value, $op, @args ) = @_;
     
     #print "Op = $op, update values = $value\n";
     $updateSubVar = $value;
     return $value;
}


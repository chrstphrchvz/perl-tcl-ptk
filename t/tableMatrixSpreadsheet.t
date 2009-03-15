# Test of the tablematrix spreadsheet widget

use Tcl::Tk (qw/ :perlTk /);
use Test;

use Tcl::Tk::Widget::TableMatrix::Spreadsheet;

plan tests => 5;

my $top = MainWindow->new;

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
	
# Check to see if empty cell sets work
$t->update; # update the table, so it's array variables will be read for the following tests
$t->set('2,2', '');

my $val = $t->get("2,2");
ok( $val, undef, "Empty value set");

# Check the cursel command for empty values
$t->set('2,2', 'newval');
$t->selection('set',  '2,2',  '2,3');
$t->curselection(''); # clear out current selection
my @indexes = $t->curselection();
#print "indexes = ".join(", ", @indexes)."\n";
my @selection = $t->get(@indexes); # read back the values just set
#print "selection = ".join(", ", @selection)."\n";
ok(scalar(@selection) , 2, 'Get Return array size');
ok(!defined($selection[0]) , 1, 'Get Return first entry undef');
ok(!defined($selection[1]) , 1, 'Get Return second entry undef');

$top->after(1000,sub{$top->destroy}) unless(@ARGV); # auto-quit unless commands supplied (for debugging)

ok(1, 1, "Spreadsheet Widget Creation");



MainLoop;

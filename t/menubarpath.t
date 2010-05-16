
use Tcl::pTk qw/:perlTk/;
use Test;

plan test => 2;

#use Tk;

my $mw;
$mw = MainWindow->new();

$| = 1;
my $toplevel = $mw;

my $menubar = $toplevel->Menu(-tearoff => 0, -type => 'menubar');

# Path before menu is made part of the toplevel should have no '#' in it.
my $path = $menubar->path;

ok($path, '.menu02');


$toplevel->configure(-menu => $menubar);

# Path after menu is made part of the toplevel (i.e. cloned by tk) should have a '#' in it.
$path = $menubar->path;

ok($path, '.#menu02');


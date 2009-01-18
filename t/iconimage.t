# Test of iconimage method. This method is implemented in Tcl as the iconphoto method,
#  which only exists is Tcl/Tk > 8.5
use Tcl::Tk (qw/:perlTk/);

use Test;
plan tests => 1;

my $top = MainWindow->new();

my $version = $top->tclVersion;
# print "version = $version\n";

# Skip if Tcl/Tk version is < 8.5
if( $version < 8.5 ){
        skip("iconimage only works for Tcl >= 8.5", 1);
        exit;
}


my $icon = $top->Photo(-file =>  Tcl::Tk->findINC("icon.gif"));

$top->iconimage($icon);

$top->after(1000,sub{$top->destroy});

MainLoop;

ok(1);


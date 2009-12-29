
#use Tk;
#use Tk::Dialog;

use strict;
use Tcl::Tk qw/:perlTk/;
use Test;


plan tests => 1;

my $top = MainWindow->new(-title => 'MessageBox Test');

$top->after(1000, sub{ $top->destroy;});
my $ans = $top->messageBox(-icon    => 'warning',
                           -title => 'MessageBox Test',
                            -type => 'YesNoCancel', -default => 'Yes',
                            -message =>
"MessageBox Test");


ok(1);



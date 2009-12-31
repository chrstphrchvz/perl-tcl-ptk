
#use Tk;
#use Tk::Dialog;

use strict;
use Tcl::Tk qw/:perlTk/;
use Test;

$Tcl::Tk::DEBUG = 1;

plan tests => 1;

my $top = MainWindow->new(-title => 'MessageBox Test');

$top->after(1000, sub{
        ok(1); 
        exit(); # No using $top->destroy here, because we get grab error messages
}
        
        );
my $ans = $top->messageBox(-icon    => 'warning',
                           -title => 'MessageBox Test',
                            -type => 'YesNoCancel', -default => 'Yes',
                            -message =>
"MessageBox Test");





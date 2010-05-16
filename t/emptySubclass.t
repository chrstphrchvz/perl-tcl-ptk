# This is a empty subclass test of the BrowseEntry widget


use Test;
plan tests => 1;
use strict;


############# Empty subclass test ####################

package Tcl::pTk::Widget::Browse2;


use base qw/Tcl::pTk::Widget::BrowseEntry/;


Construct Tcl::pTk::Widget 'Browse2';


1;

############################################################


package main;

use Tcl::pTk qw/ :perlTk/;


$| = 1;

my $top = MainWindow->new();

my $option;

my $be = $top->Browse2(-variable => \$option )->pack(-side => 'right');
$be->insert('end',qw(one two three four));


$be->pack(-side => 'top', -fill => 'x', -expand => 1);

$top->after(1000,sub{$top->destroy});

ok(1, 1, "Empty SubWidget Widget Creation");
    
MainLoop;

print "Option = $option\n" if (defined($option));



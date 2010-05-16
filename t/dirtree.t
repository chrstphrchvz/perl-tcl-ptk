# DirTree, display directory tree.

use strict;
use Test;
use Tcl::pTk qw/:perlTk/;

use Tcl::pTk::Widget::DirTree;

plan tests => 1;

my $top = MainWindow->new;
my $dl  = $top->Scrolled('DirTree')->pack(-expand => 1 , -fill => 'both');

$top->after(1000,sub{$top->destroy});

MainLoop;

ok(1);

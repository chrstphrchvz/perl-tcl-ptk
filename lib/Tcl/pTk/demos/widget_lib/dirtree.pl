# DirTree, display directory tree.

use Tcl::Tk (qw/:perlTk/);
use Tcl::Tk::Widget::DirTree;
my $top = MainWindow->new;
my $dl  = $top->Scrolled('DirTree')->pack(-expand => 1 , -fill => 'both');
MainLoop;

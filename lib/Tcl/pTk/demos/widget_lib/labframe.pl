# LabFrame, frame with embedded label.

use Tcl::Tk (qw/ :perlTk/);
#use Tcl::Tk::Widget::LabFrame;
use Tcl::Tk::Widget::LabEntry;

my $test = 'Test this';

my $top = MainWindow->new;
my $f = $top->LabFrame(-label => "This is a label", -labelside => "acrosstop");
$f->LabEntry(-label => "Testing", -textvariable => \$test)->pack;
$f->pack;
MainLoop;

# LabFrame, frame with embedded label.

use Tcl::pTk (qw/ :perlTk/);
#use Tcl::pTk::Widget::LabFrame;
use Tcl::pTk::Widget::LabEntry;

my $test = 'Test this';

my $top = MainWindow->new;
my $f = $top->LabFrame(-label => "This is a label", -labelside => "acrosstop");
$f->LabEntry(-label => "Testing", -textvariable => \$test)->pack;
$f->pack;
MainLoop;

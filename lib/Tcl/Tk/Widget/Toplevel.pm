package Tcl::Tk::Widget::Toplevel;

# Simple Toplevel package.
#  Split-out from the Tcl::Tk::Widget package for compatibility with
#   'use base (Tcl::Tk::Toplevel)' statements used in perl/tk
#

use Tcl::Tk::Widget();
use Tcl::Tk::Wm();

@Tcl::Tk::Widget::Toplevel::ISA = qw(Tcl::Tk::Wm Tcl::Tk::Widget);


sub Populate
{
 my ($cw,$arg) = @_;
 $cw->SUPER::Populate($arg);
 $cw->ConfigSpecs('-title',['METHOD',undef,undef,$cw->class]);
}

# Method to return the containerName of the widget
#   Any subclasses of this widget can call containerName to get the correct
#   container widget for the subwidget
sub containerName{
        return 'Toplevel';
}


1;


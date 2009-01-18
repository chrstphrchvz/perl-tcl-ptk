package Tcl::Tk::Widget::Bitmap;
require Tcl::Tk;
require Tcl::Tk::Widget::Image;

use base  qw(Tcl::Tk::Widget::Image);
Construct Tcl::Tk::Widget::Image 'Bitmap';
sub Tk_image { 'bitmap' }
1;
__END__

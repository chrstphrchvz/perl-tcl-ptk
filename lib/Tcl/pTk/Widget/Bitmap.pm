package Tcl::pTk::Widget::Bitmap;
require Tcl::pTk;
require Tcl::pTk::Widget::Image;

use base  qw(Tcl::pTk::Widget::Image);
Construct Tcl::pTk::Widget::Image 'Bitmap';
sub Tk_image { 'bitmap' }
1;
__END__

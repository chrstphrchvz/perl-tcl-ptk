package Tcl::Tk::Widget::Photo;


use Tcl::Tk;

use base  qw(Tcl::Tk::Widget::Image);

Construct Tcl::Tk::Widget::Image 'Photo';

sub Tk_image { 'photo' }

# These method should be autoloaded in Tcl::Tk::Widget, so we don't need to explicitly call out here
#Tcl::Tk::Methods('blank','copy','data','formats','get','put','read',
#           'redither','transparency','write');

use Tcl::Tk::Submethods (
    'transparency'  => [qw/get set/],
);

1;
__END__

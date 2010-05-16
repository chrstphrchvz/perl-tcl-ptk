# Test script for the Bitmap widget as a subclass of Image

BEGIN { $^W = 1; $| = 1;}
use strict;
use Test;
use Tcl::pTk qw/:perlTk/;
#use Tcl::pTk::Widget::Photo;
#use Tk;

my $mw  = MainWindow->new();
$mw->geometry('+100+100');



plan tests => 7;


# Check that the width/height methods work
my $bitmap = $mw->Bitmap(-file => 't/Tk.xbm');
ok($bitmap->width,  61, "bitmap->width method problem");
ok($bitmap->height, 61, "bitmap->height method problem");

my $label = $mw->Label(-image => $bitmap)->pack();


# Check to see if retreived photo works
my $image = $label->cget(-image);
ok($image->width,  61, "bitmap->width method problem");
ok($image->height, 61, "bitmap->height method problem");

my $type = $image->type();
ok($type, 'bitmap', 'Unexpected type');

# Make sure image names returns a Photo object.
my @names = $mw->imageNames();
#print "Names = ".join(", ", @names)."\n";
ok(ref($names[0]) =~ /Bitmap/i); # Check for image name being a image object

my @types = $mw->imageTypes;
#print "imageTypes = ".join(", ", @types)."\n";
ok(join(", ", sort @types), 'Bitmap, Photo, Pixmap', "Unexpected imageTypes");

# Delete the image after a second
$mw->after(1000, sub{ $image->delete });

$mw->after(2000,sub{$mw->destroy});
MainLoop;



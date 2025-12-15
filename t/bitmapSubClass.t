# Test script for the Bitmap widget as a subclass of Image

BEGIN { $| = 1; }
use warnings;
use strict;
use Test::More tests => 7;
use Test::Deep;
use Tcl::pTk;
#use Tcl::pTk::Photo;
#use Tk;

my $mw  = MainWindow->new();
$mw->geometry('+100+100');

# This will skip if Img not present
my $imagePresent = defined($Tcl::pTk::VERSION) && $mw->interp->pkg_require('Img');




# Check that the width/height methods work
my $bitmap = $mw->Bitmap(-file => 't/Tk.xbm');
is($bitmap->width,  61, "bitmap->width method problem");
is($bitmap->height, 61, "bitmap->height method problem");

my $label = $mw->Label(-image => $bitmap)->pack();


# Check to see if retrieved photo works
my $image = $label->cget(-image);
is($image->width,  61, "bitmap->width method problem");
is($image->height, 61, "bitmap->height method problem");

my $type = $image->type();
is($type, 'bitmap', 'Unexpected type');

# Make sure image names returns a Photo object.
my @names = $mw->imageNames();
#print "Names = ".join(", ", @names)."\n";
is(scalar(grep {$_ == $bitmap} @names), 1, 'Check for image name being a image object');

my @types = $mw->imageTypes;
#print "imageTypes = ".join(", ", @types)."\n";
my @expectedTypes = (qw/ Bitmap Photo Pixmap/);
pop @expectedTypes unless( $imagePresent ); # Pixmap won't be there if Img package not there
cmp_deeply(\@types, supersetof(@expectedTypes), "Missing expected imageTypes");

# Delete the image after a second
$mw->after(1000, sub{ $image->delete });

$mw->after(2000,sub{$mw->destroy});
MainLoop;



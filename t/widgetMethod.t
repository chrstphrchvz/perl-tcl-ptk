# Ensure Widget method is implemented with Perl/Tk-compatible behavior:
# - returns the same reference as when a widget was created
# - returns undef if there is no widget with the pathname
# TODO: can handling be improved for manually-wrapped widgets (i.e. those created from Tcl),
# e.g. detect specific widget class rather than always return a Tcl::pTk::Widget reference?
use warnings;
use strict;
use Test;
use Scalar::Util qw/refaddr/;
#use Tk;
use Tcl::pTk;

plan tests => 5;

my $mw = MainWindow->new;
$mw->idletasks;
my $mw_ref = $mw->Widget($mw->PathName);
ok(ref($mw_ref), ref($mw));
ok(refaddr($mw_ref), refaddr($mw));

my $e = $mw->Entry->pack;
my $e_ref = $mw->Widget($e->PathName);
ok(ref($e_ref), ref($e));
ok(refaddr($e_ref), refaddr($e));

ok($mw->Widget('.bogus'), undef);

(@ARGV) ? MainLoop : $mw->destroy;

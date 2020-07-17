# Test to check error reporting for a background error (with Tk::Error active)
#   that occurs due to a undefined sub with a user defined Tk::Error supplied
use warnings;
use strict;
use Test;
BEGIN {plan tests=>1}
use Tcl::pTk::TkHijack;
use Tk;

my $errorMess;

my $mw = MainWindow->new;


# Setup label with a scroll command that is not defined
#   This will create a background error.
my $lb = $mw->Listbox->pack;
$lb->configure(-yscrollcommand =>  \&bogus);
$lb->insert(qw/0 foo/);
$lb->update;

$mw->idletasks;
MainLoop if (@ARGV);

ok( $errorMess =~ /Got An Error/);

sub Tk::Error{
        
        $errorMess = "## Got An Error:\n".join(", ", @_)."\n";
        #print $errorMess;
}

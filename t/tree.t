#!/usr/bin/perl -w
#
# Perl/Tk version of Tix4.1.0/demos/samples/Tree.tcl.  Not quite as
# nice as the Tix version: fonts and colors are different, and the
# collapse/expand buttons are higlighted differently.
#


use strict;
use Tcl::pTk;
use Tcl::pTk::Tree;
use Test;

plan tests => 2;

my $top = MainWindow->new( -title => "Tree" );


$| = 1; # Pipes hot

my $tree = $top->Scrolled( qw/Tree -separator \ 
                           -scrollbars osoe / );

#my $tree = $top->Tree( qw/ -separator \  /);

$tree->pack( qw/-expand yes -fill both -padx 10 -pady 10 -side top/ );

my @directories = qw( C: C:\Dos C:\Windows C:\Windows\System );

foreach my $d (@directories) {
    my $text = (split( /\\/, $d ))[-1]; 
    $tree->add( $d,  -text => $text, -image => $tree->Getimage("folder") );
}

$tree->configure( -command => sub { print "@_\n" } );


# The tree is fully expanded by default.
$tree->autosetmode();


my $ind = $tree->cget(-indicatorcmd);
ok(ref($ind), "Tcl::pTk::Callback", "-indicatormcd returns callback");

ok(1, 1, "Tree Widget Creation");
 
$top->after(1000,sub{$top->destroy});

MainLoop();

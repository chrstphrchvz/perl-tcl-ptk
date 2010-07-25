# Example of using the TixTree widget directly from Tcl::pTk

use strict;
use Test;
use Tcl::pTk;

plan tests => 1;

my $top = MainWindow->new( -title => "TixTree" );


my $tree = $top->TixTree();

my $hlist = $tree->Subwidget('hlist');

$hlist->configure(-separator => '/', -selectbackground => 'lightsteelblue4', -selectforeground => 'white');
foreach my $i( 0..1){
        $hlist->add( $i, -itemtype => 'imagetext', -text => "Folder $i", -image => $top->Getimage('folder')); #, -image => $image);
        
        foreach my $j( 0..4){
                $hlist->add("$i/$j", -itemtype => 'imagetext', -text => "File $i/$j", -image => $top->Getimage('textfile')); #, -image => $image);
        }       
}


$tree->autosetmode();

$tree->pack();

$top->after(1000,sub{$top->destroy});

MainLoop;

ok(1, 1, "TixTree Widget Creation");


#!/usr/local/bin/nperl -w

use Tcl::Tk qw/:perlTk/;
use Data::Dumper;
use Test;

plan tests => 1;

$mw = MainWindow->new;
$|=1;

my $hl = $mw->Scrolled('HList', -separator => '.', -width => 25,
#my $hl = $mw->HList( -separator => '.', -width => 25,
                        -drawbranch => 1,
                        -selectmode => 'extended', -columns => 2,
                        -indent => 10);

$hl->configure( -command => [ sub
                               {
                                my $hl = shift;
                                my $ent = shift;
                                my $data = $hl->info('data',$ent);
                                print "Data = ".Data::Dumper::Dumper($data)."\n";
                                foreach ($hl,$ent,$data)
                                 {
                                  print ref($_) ? "ref $_\n" : "string $_\n";
                                 }
                                print "\n";
                               }, $hl
                             ]
               );

$hl->pack(-expand => 1, -fill => 'both');

@list = qw(one two three);

my $i = 0;
foreach my $item (@list)
 {
  $hl->add($item, -itemtype => 'text', -text => $item, -data => {});
  my $subitem;
  foreach $subitem (@list)
   {
    $hl->addchild($item, -itemtype => 'text', -text => $subitem, -data => []);
   }
 }
 
 # Add an item that will be deleted
 $hl->add("deleteItem", -itemtype => 'text', -text => 'deleteItem');
 $hl->delete("entry", "deleteItem");

ok(1, 1, "HList Widget Creation");
 
$mw->after(1000,sub{$mw->destroy}) unless(@ARGV);

MainLoop;

# Test to see if a subclass of a auto-loaded widget (Menu) can be created without
#   creating an instance of the auto-loaded widget first


use strict;

use Tcl::Tk (qw/ :perlTk /);

use Test;

plan tests => 2;

my $mw = MainWindow->new();


my $label = $mw->Button2(-text => 'Button')->pack();

#my $menu = $mw->Menu();
my $popup = $mw->Menu2('-tearoff' => 0);
$popup->command('-label' => 'Plot Options...' );
$popup->command('-label' => 'Label Point' );
$popup->separator;
$popup->command('-label' => 'Dump Data...');

$popup->command('-label' => 'Print...');

my @popconfig = $popup->configure(-popover);
ok( $popconfig[0] eq '-popover'); # check for proper return value from config

$label->bind('<ButtonPress-3>', 
        sub{
                $popup->Popup(-popover => 'cursor', '-popanchor' => 'nw');
        }
        );


$mw->after(2000,sub{$mw->destroy}) unless (@ARGV); # Persist if any args supplied, for debugging


MainLoop;

ok(1);



BEGIN{
        
#### Empty Menu Subclass #####
package Tcl::Tk::Widget::Menu2;

@Tcl::Tk::Widget::Menu2::ISA = (qw/ Tcl::Tk::Derived Tcl::Tk::Widget::Menu/);

Construct Tcl::Tk::Widget 'Menu2';

#### Empty Button Subclass #####
package Tcl::Tk::Widget::Button2;

@Tcl::Tk::Widget::Button2::ISA = (qw/ Tcl::Tk::Derived Tcl::Tk::Widget::Button/);

Construct Tcl::Tk::Widget 'Button2';

}

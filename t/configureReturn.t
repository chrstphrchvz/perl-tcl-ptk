# Test to make sure configure with no-args returns a 2-d array (or nothing) for
#   a large set of widgets

use Tcl::pTk;
use Tcl::pTk::widgets(TextUndo);
use Test;

plan tests => 20;

$mw = MainWindow->new;
$|=1;

my @widgets = ( qw/ Button Checkbutton  Entry  LabelFrame Label 
        Listbox Message Menu Menubutton Panedwindow Radiobutton Text 
         Scale TextUndo  Frame Scrollbar  Canvas   HList TList NoteBook/);

foreach my $widgetName (@widgets){
        
        my $widget = $mw->$widgetName();
        
        my @configure = $widget->configure();
        
        if( @configure == 0 or ref($configure[0])){
                ok(1);  # "Widget $widget configure");
        }
        else{
                ok(0, 1,   "$widgetName configure doesn't return 2D Array");
        }
}
 

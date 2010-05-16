use Tcl::pTk;
use Tcl::pTk::Widget::BrowseEntry;
use Tcl::pTk::Widget::ttkBrowseEntry;

package Tcl::pTk::TkFacelift;

=head1 NAME

Tcl::pTk::TkFacelift -  Update the look of older Tk scripts using the new tile widgets


=head1 SYNOPSIS

        # Run a existing tcl/tk script 'tcltkscript.pl' with an updated look
        perl -MTcl::pTk::TkFacelift tcltkscript.pl
        
        # Alternatively, you can just put 'use Tcl::pTk::TkFacelift' at the
        #  top of the 'tcltkscript.pl' file and just run it like normal

        # You can also do this in combination with Tcl::pTk::TkHijack to run
        #  an existing perl/tk script using Tcl::pTk and with an updated look
        #  
        perl -MTcl::pTk::TkHijack -MTcl::pTk::TkFacelift tkscript.pl

=head1 DESCRIPTION

I<Tcl::pTk::TkFacelift> is an experimental module that gives existing tcl/tk scripts an updated look by subsituting
some the widgets (button, entry, label, etc) with their new "Tile" widget equivalents.
        
Note that this replacement/subsitution is not complete. The new "Tile" widgets aren't 100% compatible with the
older widgets. To take full advantage of the new Tcl/Tk "Tile" widgets, 
you should re-code your application to specifically take advantage of them.

This package only replaces some of the basic widgets (e.g. button, label, entry, etc) with their tile-widget equivalents.

=head1 How It Works

New widgets are created that override the creation-methods for the old widgets. These new methods create the new "Tile"
widgets, instead of the old widgets.
        
For Example, this code snippet would create a top-level window, and a Label and Button widget 
 
 use Tcl::pTk (qw/ :perlTk /);
 my $mw     = MainWindow->new();
 my $label  = $mw->Label();
 my $button = $mw->Button();
 
Now, with the addition of the C<use Tcl::pTk::TkFacelift> package, the I<Label> and <Button> creation-methods
get over-ridden to build "Tile" widgets.
        
 use Tcl::pTk (qw/ :perlTk /);
 use Tcl::pTk::TkFacelift;
 my $mw     = MainWindow->new();
 my $label  = $mw->Label();
 my $button = $mw->Button();

B<Note:> The new widgets created in this package have the same options as the old widget, but where there is no
equivalent option in the new "Tile" widget, the option is ignored.
        
For example, most appearance-related options that are present in the old widgets don't exist in the new "Tile" widgets,
because Tile-widgets appearances are controlled using "Themes". So the -bg (background color) option that exists for an old "button" widget
doesn't exist in the new "ttkButton" widget. For better compatibility with existing scripts, the Tile-subsitution
widgets (e.g. the Button, Entry, etc widgets) created in this package will have
a appearance options (e.g. -bg, -fg, etc) option, but they will be ignored. 

=head1 Examples

There are some examples of using TkFacelift (along with TkHijack) with a simple perl/tk script, and a perl/tk mega-widget. See
C<t/tkFacelift_simple.t> and C<t/tkFacelift_mega.t> in the source distribution.

=head1 LIMITATIONS

=over 1

=item *

Substitutes for all the old widgets aren't provided

=item *

Options in the old widgets that aren't present the new Tile widgets are simply ignored.

=back

=cut

############# Substitution Package for oldwidget "Radiobutton" to tile widget "ttkRadiobutton" ####################

package Tcl::pTk::Widget::RadiobuttonttkSubs;


@Tcl::pTk::Widget::RadiobuttonttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget/);


Construct Tcl::pTk::Widget 'Radiobutton';



sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -activebackground,
     -activeforeground,
     -anchor,
     -background,
     -bd,
     -bg,
     -bitmap,
     -borderwidth,
     -disabledforeground,
     -fg,
     -font,
     -foreground,
     -height,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -indicatoron,
     -justify,
     -offrelief,
     -overrelief,
     -padx,
     -pady,
     -relief,
     -selectcolor,
     -selectimage,
     -tristateimage,
     -tristatevalue,
     -wraplength

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}



sub containerName{
        return 'ttkRadiobutton';
}



1;

############################################################


############# Substitution Package for oldwidget "Button" to tile widget "ttkButton" ####################

package Tcl::pTk::Widget::ButtonttkSubs;


@Tcl::pTk::Widget::ButtonttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget/);


Construct Tcl::pTk::Widget 'Button';


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -activebackground,
     -activeforeground,
     -anchor,
     -background,
     -bd,
     -bg,
     -bitmap,
     -borderwidth,
     -disabledforeground,
     -fg,
     -font,
     -foreground,
     -height,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -justify,
     -overrelief,
     -padx,
     -pady,
     -relief,
     -repeatdelay,
     -repeatinterval,
     -wraplength

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}



sub containerName{
        return 'ttkButton';
}



1;

############################################################


############# Substitution Package for oldwidget "Entry" to tile widget "ttkEntry" ####################

package Tcl::pTk::Widget::EntryttkSubs;


@Tcl::pTk::Widget::EntryttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget/);


Construct Tcl::pTk::Widget 'Entry';


sub Populate {
    my( $cw, $args ) = @_;
    
    # Set foreground and background options to undef, unless defined during widget creation
    #   This keeps Tcl::pTk::Derived from setting these options from the options database, which is
    #    not needed for ttk widgets, and also makes -state => 'disabled' not look right
    foreach my $option( qw/ -foreground -background /){
            $args->{$option} = undef unless( defined($args->{$option} ));
    }


    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -bd,
     -bg,
     -borderwidth,
     -disabledbackground,
     -disabledforeground,
     -fg,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -insertbackground,
     -insertborderwidth,
     -insertofftime,
     -insertontime,
     -insertwidth,
     -invcmd,
     -readonlybackground,
     -relief,
     -selectbackground,
     -selectborderwidth,
     -selectforeground,
     -vcmd

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}



sub containerName{
        return 'ttkEntry';
}



1;

############################################################


############# Substitution Package for oldwidget "Frame" to tile widget "ttkFrame" ####################

package Tcl::pTk::Widget::FramettkSubs;


@Tcl::pTk::Widget::FramettkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget::Frame/);


Construct Tcl::pTk::Widget 'Frame';


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -background,
     -bd,
     -colormap,
     -container,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -padx,
     -pady,
     -visual

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}


sub containerName{
        return 'ttkFrame';
}


#Add -class to the list of options that will (if present) be fed to the base widget at creation
sub CreateOptions{
        my $self = shift;
        return ($self->SUPER::CreateOptions, "-class");
}



# Wrapper sub so frame-based mega-widgets still work with the facelift
sub Tcl::pTk::Frame{
        my $self = shift;
        my $obj = $self->Tcl::pTk::ttkFrame(@_);
        bless $obj, "Tcl::pTk::Widget::FramettkSubs";
        return $obj;
}


1;

############################################################


############# Substitution Package for oldwidget "Checkbutton" to tile widget "ttkCheckbutton" ####################

package Tcl::pTk::Widget::CheckbuttonttkSubs;


@Tcl::pTk::Widget::CheckbuttonttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget/);


Construct Tcl::pTk::Widget 'Checkbutton';


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -activebackground,
     -activeforeground,
     -anchor,
     -background,
     -bd,
     -bg,
     -bitmap,
     -borderwidth,
     -disabledforeground,
     -fg,
     -font,
     -foreground,
     -height,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -indicatoron,
     -justify,
     -offrelief,
     -overrelief,
     -padx,
     -pady,
     -relief,
     -selectcolor,
     -selectimage,
     -tristateimage,
     -tristatevalue,
     -wraplength

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}



sub containerName{
        return 'ttkCheckbutton';
}



1;

############################################################


############# Substitution Package for oldwidget "Label" to tile widget "ttkLabel" ####################

package Tcl::pTk::Widget::LabelttkSubs;


@Tcl::pTk::Widget::LabelttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget/);


Construct Tcl::pTk::Widget 'Label';


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );


    #### Setup options ###
    
    
    # Setup options that will be ignored  (setup to just be passive), because they don't
    #  exists in the subsituted tile widget
    my @ignoreOptions = (
     -activebackground,
     -activeforeground,
     -bd,
     -bitmap,
     -disabledforeground,
     -height,
     -highlightbackground,
     -highlightcolor,
     -highlightthickness,
     -padx,
     -pady

    );
    
    my %ignoreConfigSpecs = map( ($_ => [ "PASSIVE", $_, $_, undef ]), @ignoreOptions);
    #  gridded and sticky are here to emulate the original Tk::Pane version
    #  They don't do anything in this widget
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['SELF']
    );



}



sub containerName{
        return 'ttkLabel';
}


# Wrapper sub so mega-widgets still work with the facelift
sub Tcl::pTk::Label{
        my $self = shift;
        my $obj = $self->Tcl::pTk::ttkLabel(@_);
        bless $obj, "Tcl::pTk::Widget::LabelttkSubs";
        return $obj;
}


1;

############################################################

############# Substitution Package for oldwidget "BrowseEntry" to tile widget "ttkBrowseEntry" ####################

package Tcl::pTk::Widget::BrowseEntryttkSubs;


@Tcl::pTk::Widget::BrowseEntryttkSubs::ISA = (qw / Tcl::pTk::Derived Tcl::pTk::Widget::ttkBrowseEntry/);

{
        local $^W = 0; # To avoid subroutine redefined warning messages
        Construct Tcl::pTk::Widget 'BrowseEntry';
}


# If we are being used in conjunction with TkHijack, we don't need a mapping for Tk::BrowseEntry
if( defined $Tcl::pTk::TkHijack::translateList){
        #print STDERR "undoing translatelist\n";
        $Tcl::pTk::TkHijack::translateList->{'Tk/BrowseEntry.pm'}    =  '';
}


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );

    # Create LabEntry subwidget (won't be visible/packed)
    my $be = $cw->LabEntry();
    $cw->Advertise('entry' => $be);
    
    my %ignoreConfigSpecs = ();
    $cw->ConfigSpecs(
        %ignoreConfigSpecs,
        'DEFAULT' => ['combobox']
    );



}

# Alias the entire BrowseEntry namespace to ttkBrowseEntry, so Browse-Entry subclasses widgets
#   work correctly
*Tcl::pTk::Widget::BrowseEntry:: = *Tcl::pTk::Widget::ttkBrowseEntry::;

# Redefine the BrowseEntry Mapping if TkHijack loaded, so BrowseEntry subclasses will still work
*Tk::BrowseEntry:: = *Tcl::pTk::Widget::BrowseEntry:: if( defined $Tcl::pTk::TkHijack::packageAliases );


# Wrapper sub so mega-widgets still work with the facelift
sub Tcl::pTk::BrowseEntry{
        my $self = shift;
        my $obj = $self->Tcl::pTk::ttkBrowseEntry(@_);
        bless $obj, "Tcl::pTk::Widget::BrowseEntryttkSubs";
        return $obj;
}

################ New Tcl::pTk::Widget::Contruct Method used for TkFacelift #########
##
##  This has the same function as Tcl::pTk::Widget::Construct defined in MegaWidget.pm
##   but also has code to alter the inheritance of derived widgets so that they are
##   properly face-lifted.
##   For example, 
# This "Constructs" a creation method for megawidgets and derived widgets

{

        
        # Mapping of superclass inheritance. e.g Tk::Frame inheritance should be mapped to FramettkSubs inheritance
        my %hijackInheritance = (
                'Tk::Frame'                    => 'Tcl::pTk::Widget::FramettkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Frame'       => 'Tcl::pTk::Widget::FramettkSubs', # For normal Tcl::pTk widgets
                'Tk::Radiobutton'              => 'Tcl::pTk::Widget::RadiobuttonettkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Radiobutton' => 'Tcl::pTk::Widget::RadiobuttonettkSubs', # For normal Tcl::pTk widgets
                'Tk::Button'                   => 'Tcl::pTk::Widget::ButtonttkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Button'      => 'Tcl::pTk::Widget::ButtonttkSubs', # For normal Tcl::pTk widgets
                'Tk::Entry'                    => 'Tcl::pTk::Widget::EntryttkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Entry'       => 'Tcl::pTk::Widget::EntryttkSubs', # For normal Tcl::pTk widgets
                'Tk::Checkbutton'              => 'Tcl::pTk::Widget::CheckbuttonttkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Checkbutton' => 'Tcl::pTk::Widget::CheckbuttonttkSubs', # For normal Tcl::pTk widgets
                'Tk::Label'                    => 'Tcl::pTk::Widget::LabelbuttonttkSubs', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::Label'       => 'Tcl::pTk::Widget::LabelbuttonttkSubs', # For normal Tcl::pTk widgets
                'Tk::BrowseEntry'              => 'Tcl::pTk::Widget::BrowseEntry', # For Hijack Tk Widgets
                'Tcl::pTk::Widget::BrowseEntry' => 'Tcl::pTk::Widget::BrowseEntryttkSubs', # For normal Tcl::pTk widgets
                );
        
        # Save the existing Construct method. We will chain to that at the end of our routine 
        BEGIN{
        *Tcl::pTk::Widget::Construct2 = \&Tcl::pTk::Widget::Construct;
        }
        
        no warnings;
        
        sub Tcl::pTk::Widget::Construct
        {
         my ($base,$name) = @_;
         my $class = (caller(0))[0];
         no strict 'refs';
        
         
         my @parents = @{"$class\::ISA"};
         #print "Hijacked Construct: $class = $class, ISA = ".join(", ", @parents)."\n";
         foreach my $parent(@{"$class\::ISA"}){
                 if( defined($hijackInheritance{$parent}) && $class ne $hijackInheritance{$parent}){
                         #print "setting ISA element $parent to ".$hijackInheritance{$parent}."\n";
                         $parent = $hijackInheritance{$parent};
                 }
         }
         
         # Go to the normal Construct
         goto \&Tcl::pTk::Widget::Construct2;
         
        }
        
        }

1;


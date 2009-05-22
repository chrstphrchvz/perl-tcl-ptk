
use Tcl::Tk ( qw/ MainLoop DoOneEvent tkinit update Ev Exists /); # Don't import MainLoop, we create our own later

package Tcl::Tk::TkHijack;

=head1 NAME

Tcl::Tk::TkHijack -  Run Existing Perl/tk Scripts with Tcl::Tk


=head1 SYNOPSIS

        # Run a existing perl/tk script 'tkscript.pl' with Tcl::Tk
        perl -MTcl::Tk::TkHijack tkscript.pl
        
        # Alternatively, you can just put 'use Tcl::Tk::TkHijack' at the
        #  top of the 'tkscript.pl' file and just run it like normal

=head1 DESCRIPTION

I<Tcl::Tk::TkHijack> is an experimental module that makes existing perl/tk use L<Tcl::Tk> to run.
It 'Hijacks' any 'use Tk' and related calls in a perl/tk script to use Tcl::Tk.

=head1 How It Works

A sub ref (tkHijack) is pushed onto perl's global @INC array. This sub intercepts any 'use Tk'
or related calls and substitutes them with their Tcl::Tk equivalents. Additionally, some package aliases are setup between the Tk and the Tcl::Tk namespace

=head1 Examples

There are some examples of using TkHijack with a simple perl/tk script, and a perl/tk mega-widget. See
C<t/tkHijack_simple.t> and C<t/tkHijack_mega.t> in the source distribution.

=head1 LIMITATIONS

=over 1

=item *

XEvent calls are not translated, because there is no equivalent in Tcl::Tk (XEvent was a perl/tk specific addition to Tk, and doesn't exists in Tcl/Tk)

=item *

Perl/Tk widgets that use XS code can't be handled with this package.

=back

=cut

our($debug, $translateList, $packageAliases, $aliasesMade);

unshift @INC, \&TkHijack;

######### Package Globals ####    
$debug = 1;


# Mapping of Tk Packages that have equivalence in Tcl::Tk.
#   If a Tk package is mapped to undef, then that means it's functionality is already included
#   in the main Tcl::Tk package.
#  This list is used for mapping "use" statements, for example if
#    "use Tk::Tree" is encountered, the file "Tcl/Tk/Widget/Tree.pm" is loaded instead
$translateList = { 
        'Tk.pm'         =>  '',
        'Tk/Tree.pm'    =>  'Tcl/Tk/Widget/Tree.pm',
        'Tk/Balloon.pm'    =>  '',
        'Tk/Bitmap.pm'    =>  '',
        'Tk/BrowseEntry.pm'    =>  'Tcl/Tk/Widget/BrowseEntry.pm',
        'Tk/Canvas.pm'    =>  'Tcl/Tk/Widget/Canvas.pm',
        'Tk/Clipboard.pm'    =>  'Tcl/Tk/Widget/Clipboard.pm',
        'Tk/Dialog.pm'    =>  '',
        'Tk/DialogBox.pm'    =>  '',
        'Tk/DirTree.pm'    =>  'Tcl/Tk/Widget/DirTree.pm',
        'Tk/DragDrop.pm'    =>  'Tcl/Tk/Widget/DragDrop.pm',
        'Tk/DropSite.pm'    =>  'Tcl/Tk/Widget/DropSite.pm',
        'Tk/Frame.pm'       =>  '',
        'Tk/Font.pm'       =>  '',
        'Tk/HList.pm'    =>  'Tcl/Tk/Widget/HList.pm',
        'Tk/Image.pm'    =>  'Tcl/Tk/Widget/Image.pm',
        'Tk/ItemStyle.pm'    =>  'Tcl/Tk/Widget/ItemStyle.pm',
        'Tk/LabEntry.pm'    =>  '',
        'Tk/Listbox.pm'    =>  'Tcl/Tk/Widget/Listbox.pm',
        'Tk/MainWindow.pm'    =>  'Tcl/Tk/Widget/MainWindow.pm',
        'Tk/Photo.pm'    =>  'Tcl/Tk/Widget/Photo.pm',
        'Tk/ProgressBar.pm'    =>  'Tcl/Tk/Widget/ProgressBar.pm',
        'Tk/ROText.pm'    =>  'Tcl/Tk/Widget/ROText.pm',
        'Tk/Table.pm'    =>  'Tcl/Tk/Widget/Table.pm',
        'Tk/Text.pm'    =>  'Tcl/Tk/Widget/Text.pm',
        'Tk/TextEdit.pm'    =>  'Tcl/Tk/Widget/TextEdit.pm',
        'Tk/TextUndo.pm'    =>  'Tcl/Tk/Widget/TextUndo.pm',
        'Tk/Toplevel.pm'    =>  '',
        'Tk/Tiler.pm'    =>  'Tcl/Tk/Widget/Tiler.pm',
        'Tk/widgets.pm' =>  'Tcl/Tk/widgets.pm',
        'Tk/LabFrame.pm' => '',
        'Tk/Submethods.pm' => 'Tcl/Tk/Widget/Submethods.pm',
        'Tk/Menu.pm'       => '',
        'Tk/Wm.pm'            => 'Tcl/Tk/Wm.pm',
        'Tk/Widget.pm'      => '',
        'Tk/After.pm'       => '',
        'Tk/Derived.pm'     => '',
        'Tk/NoteBook.pm'     => '',
        'Tk/NBFrame.pm'     => '',
        'Tk/Pane.pm'     => 'Tcl/Tk/Widget/Pane.pm',
        'Tk/TableMatrix.pm'     => 'Tcl/Tk/Widget/TableMatrix.pm',
        'Tk/TableMatrix/Spreadsheet.pm'     => 'Tcl/Tk/Widget/TableMatrix/Spreadsheet.pm',
        'Tk/TableMatrix/SpreadsheetHideRows.pm'     => 'Tcl/Tk/Widget/TableMatrix/SpreadsheetHideRows.pm',
};


# List of alias that will be created for Tk packages to Tcl::Tk packages
#   This is to make megawidgets created in Tk work. For example,
#     if a Tk mega widget has the following code:
#       use base(qw/ Tk::Frame /);
#       Construct Tk::Widget 'SlideSwitch'
#     The aliases below will essentially translate to code to mean:
#       use base(qw/ Tcl::Tk::Widget::Frame /);
#       Construct Tcl::Tk::Widget 'SlideSwitch'
#       
$packageAliases = {
        'Tk::Frame' => 'Tcl::Tk::Widget::Frame',
        'Tk::Toplevel' => 'Tcl::Tk::Widget::Toplevel',
        'Tk::MainWindow' => 'Tcl::Tk::Widget::MainWindow',
        'Tk::Widget'=> 'Tcl::Tk::Widget',
        'Tk::Derived'=> 'Tcl::Tk::Derived',
        'Tk::DropSite'    =>  'Tcl::Tk::Widget::DropSite',
        'Tk::Canvas'    =>  'Tcl::Tk::Widget::Canvas',
        'Tk::Menu'=> 'Tcl::Tk::Widget::Menu',
        'Tk::TextUndo'=> 'Tcl::Tk::Widget::TextUndo',
        'Tk::Text'=> 'Tcl::Tk::Widget::Text',
        'Tk::Tree'=> 'Tcl::Tk::Widget::Tree',
        'Tk::Clipboard'=> 'Tcl::Tk::Widget::Clipboard',
        'Tk::BrowseEntry'=> 'Tcl::Tk::Widget::BrowseEntry',
        'Tk::Callback'=> 'Tcl::Tk::Callback',
        'Tk::TableMatrix'=> 'Tcl::Tk::Widget::TableMatrix',
        'Tk::Table'=> 'Tcl::Tk::Widget::Table',
        'Tk::TableMatrix::Spreadsheet'=> 'Tcl::Tk::Widget::TableMatrix::Spreadsheet',
        'Tk::TableMatrix::SpreadsheetHideRows'=> 'Tcl::Tk::Widget::TableMatrix::SpreadsheetHideRows',
};
  
######### End of Package Globals ###########
# Alias Packages
aliasPackages($packageAliases);





sub TkHijack {
    # When placed first on the INC path, this will allow us to hijack
    # any requests for 'use Tk' and any Tk::* modules and replace them
    # with our own stuff.
    my ($coderef, $module) = @_;  # $coderef is to myself
    #print "TkHijack encoutering $module\n";
    return undef unless $module =~ m!^Tk(/|\.pm$)!;
    
    #print "TkHijack $module\n";

    my ($package, $callerfile, $callerline) = caller;
    #print "TkHijack package/callerFile/callerline = $package $callerfile $callerline\n";
    
    my $mapped = $translateList->{$module};
    
    if( defined($mapped) && !$mapped){ # Module exists in translateList, but no mapped file
            my $fakefile;
            open(my $fh, '<', \$fakefile) || die "oops"; # open a file "in-memory"
        
            $module =~ s!/!::!g;
            $module =~ s/\.pm$//;
        
            # Make Version if importing Tk (needed for some scripts to work right)
            my $versionText = "\n";
            my $requireText = "\n"; #  if Tk module, set export of Ev subs
            if( $module eq 'Tk' ){
                    
                    $requireText = "use Exporter 'import';\n";
                    $requireText .= '@EXPORT_OK = (qw/ Ev catch/);'."\n";
                    
                    $versionText = '$Tk::VERSION = 805.001;'."\n";
                    
                    # Redefine common Tk subs/variables to Tcl::Tk equivalents
                    no warnings;
                    *Tk::MainLoop = \&Tcl::Tk::MainLoop;
                    *Tk::findINC = \&Tcl::Tk::findINC;
                    *Tk::after = \&Tcl::Tk::after;
                    *Tk::DoOneEvent = \&Tcl::Tk::DoOneEvent;
                    *Tk::Ev = \&Tcl::Tk::Ev;
                    *Tk::Exists = \&Tcl::Tk::Exists;
                    *Tk::break = \&Tcl::Tk::break;
                    *Tk::platform = \$Tcl::Tk::platform;
                    *Tk::bind = \&Tcl::Tk::Widget::bind;
                    *Tk::ACTIVE_BG = \&Tcl::Tk::ACTIVE_BG;
                    *Tk::NORMAL_BG = \&Tcl::Tk::NORMAL_BG;
                    *Tk::SELECT_BG = \&Tcl::Tk::SELECT_BG;
                    
                    
            }
        
        
            $fakefile = <<EOS;
        package $module;
        $requireText
        $versionText
        #warn "### $callerfile:$callerline not really loading $module ###" if($Tcl::Tk::TkHijack::debug);
        sub foo { 1; }
        1;
EOS
        return $fh;
    }
    elsif( defined($mapped) ){ # Module exists in translateList with a mapped file

            # Turn mapped file into name suitable for a 'use' statement
            my $usefile = $mapped;
            $usefile =~ s!/!::!g;
            $usefile =~ s/\.pm$//;

            #warn "### $callerfile:$callerline loading Tcl Tk $usefile to substitute for $module ###" if($Tcl::Tk::TkHijack::debug);
            # Turn mapped file into use statement
            my $fakefile;
            open(my $fh, '<', \$fakefile) || die "oops"; # open a file "in-memory"
             $fakefile = <<EOS;
        use $usefile;
        1;
EOS
             return $fh;       
    }
    else{
            #warn("Warning No Tcl::Tk Equivalent to $module from $callerfile line $callerline, loading anyway...\n") if $debug;
    }
            
}

############## Sub To Alias Packages ########
sub aliasPackages{
        my $aliases = shift;
        my $aliasTo;
        foreach my $aliasFrom ( keys %$aliases){
            $aliasTo = $packageAliases->{$aliasFrom};
            *{$aliasFrom.'::'} = *{$aliasTo.'::'};
        }
}


################### MainWindow package #################3
## Created so the lines like the following work
##   my $mw = new MainWindow;
package MainWindow;

sub new{
        Tcl::Tk::MainWindow();
}

1;

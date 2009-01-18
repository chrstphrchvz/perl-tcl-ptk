package Tcl::Tk::Tile;

use strict;
use warnings;
use Carp;

=head1 NAME

Tcl::Tk::Tile -  Tile/ttk Widget Support for Tcl::Tk


=head1 SYNOPSIS

        # Get a list of defined Tile Themes
        my @themes = $widget->ttkThemes;
        
        # Set a Tile Theme
        $widget->ttkSetTheme($themeName);
        
        # Create a Tile/ttk widget
        my $check->ttkCheckbutton(-text => 'Enabled', -variable => \$enabled);

=head1 DESCRIPTION

I<Tcl::Tk::Tile> provides some helper methods for Tile/ttk support L<Tcl::Tk> package. Tile/ttk are the
new themed widget set that is present in Tcl version 8.5 and above.
        
This package is auto-loaded and the tile widgets declared if a Tcl version > 8.5 is being used by Tcl::Tk.

=head1 METHODS

=cut

##################################################

=head2 ttkSetTheme

Set a Tile Theme
        
B<Usage:>

        $widget->ttkSetTheme($name);

=cut

sub Tcl::Tk::Widget::ttkSetTheme{
        my $self = shift;
        
        my $theme = shift;

        $self->interp->call('ttk::setTheme', $theme);
        
}

##################################################

=head2 ttkThemes

Get a list of Tile/ttk theme names
        
B<Usage:>

        my @themes $widget->ttkThemes;

=cut

sub Tcl::Tk::Widget::ttkThemes{
        my $self = shift;
        

        $self->interp->call('ttk::themes');
        
}

##################################################

=head2 _declareTileWidgets

Internal sub to declare the tile widgets. This is called when a mainwindow is created, if we are
using a Tcl version >= 8.5.

B<Usage:>

        _declareTileWidgets($interp);
        
        where $interp is the Tcl interp object

=cut

sub _declareTileWidgets{
        my $interp = shift;
        
        my  @ttkwidgets = ( qw/ 
                button checkbutton combobox entry frame image label
                label labelframe menubutton notebook panedwindow
                progressbar radiobutton scale scrollbar separator
                sizegrip treeview /);
        
        foreach my $ttkwidget(@ttkwidgets){
                #print STDERR "delcareing "."ttk".ucfirst($ttkwidget).
                #                 "  ttk::$ttkwidget\n";
                $interp->Declare("ttk".ucfirst($ttkwidget),
                                 "ttk::$ttkwidget", -require => 'Ttk');
        }
         
}


1;

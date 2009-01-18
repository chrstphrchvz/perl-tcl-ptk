=head1 NAME 

Tcl::Tk::Widget::ttkBrowseEntry - Widget to Display Pulse Timing Diagrams based on Instrument Settings

=head1 SYNOPSIS

 use Tk;
 use Tk::InstTimingDisplay;

 my $top = MainWindow->new(-title => 'Timing Diagram');
   
 # Create a diagram
 my $diagram = $top->InstTimingDisplay(
                  -mappingText => $mappingText,  # Text of the instrument setting mapping tables
                  -pulseOrder  => $pulseOrder,   # Order to display the pulses
               )->pack(-fill => 'both', -expand => 'y');
 

=head1 DESCRIPTION

This is a Tk widget (Subclass of L<Tk::TimingDisplay>) for displaying simple Pulse Timing Diagrams from instrument settings. 
It is very similar to L<Tk::TimingDisplay>, but instead of directly specifying pulse parameters, a mapping
table is supplied that tells the widget which instrument settings names should be translated to pulse parameters. This
results in a live timing diagram that updates when any instrument pulse setting parameters are updated.

=head1 OPTIONS

In addition to the options of the parent widget, this widget recognizes the following options:

=over 1

=item mappingText

Text for the mapping tables. See the docs for the I<readTxtMappingTable> for an example of the format.
        

=back 

=head1 ATTRIBUTES

=over 1

=item inputMapping

Hash ref of input mapping structure. This is of the form
 
 { InstrumentName => { Setting =>  VariableName} }

This specifies which instrument and setting this object listens to, and what variable that this setting gets
translated to in the mapping process.
        
Here is an example of the structure, where the widget is setup to listen to the C<TxMod> and C<TX> instrument
settings. C<ActiveLevel> settings from C<TxMod> result in the variable name C<$TxMod_ActiveLevel> (in a private
namespace) being set.

 {
    'TxMod' => 
        {'ActiveLevel' => 'TxMod_ActiveLevel',
         'Delay'       => 'TxMod_Delay' ,
         'Width'       => 'TxMod_Width',
        },
    'TX'    => 
         {'ActiveLevel' => 'TX_ActiveLevel',
         'Delay'       => 'TX_Delay' ,
         'Width'       => 'TX_Width',
        },
 }

=item outputMapping

Hash ref of output mapping structure. This is of the form
 
 { PulseName => { PulseSetting =>  EqnCode } }

This specifies some equation code to execute for each pulse and pulseSetting in the timing display.
The equation code is executed in a private namespace where the variable-names from the inputMapping are defined.
        
Here is an example of the structure, where the pulses I<TxModpulse> and I<TXpulse> are defined (I<_None> is reserved
for overall pulse parameters, like I<TotalPeriod>.) 

 {
    'TxModpulse' => 
        {'ActiveLevel' => '$TxMod_ActiveLevel',
         'Delay'       => '$TxMod_Delay' ,
         'Width'       => '$TxMod_Width',
        },
    'TXpulse'    =>
        {'ActiveLevel' => '$Tx_ActiveLevel',
         'Delay'       => '$Tx_Delay' ,
         'Width'       => '$Tx_Width',
        },
    '_None'          =>
        { 'TotalPeriod'  => '1/$PRF*1000 unless(!$PRF)' }
 }
 
=item outputMappingSubs

Hash ref of output mapping, with the code-snippets of C<outputMapping> turned into sub-refs. This is done
when the object is created so that these sub-refs can just be executed in the I<statusChanged> method, rather
than I<eval>-ing the code snippets for each call of I<statusChanged>, which would be slow. 

=item sandBoxPackage

Name of the private namepace (i.e. "sandbox" package name) that the mapping variables and code are created
in.

=back

=cut

package Tcl::Tk::Widget::ttkBrowseEntry;

use Tcl::Tk qw(Ev);
use Carp;
use strict;

# Set ISA of superclass widget, to avoid warnings
@Tcl::Tk::Widget::ttkCombobox::ISA = ( qw/ Tcl::Tk::Widget/);

# Set Inheritance
@Tcl::Tk::Widget::ttkBrowseEntry::ISA = ( qw/ Tcl::Tk::Derived Tcl::Tk::Widget::ttkCombobox/);
Construct Tcl::Tk::Widget 'ttkBrowseEntry';

sub Populate {
    my ($cw, $args) = @_;
     
    $cw->SUPER::Populate($args);
    

    $cw->ConfigSpecs( 
		      DEFAULT => [ 'SELF' ],  # Default options go to ttkCombobox
                      -arrowimage      => ['PASSIVE', 'arrowimage', 'arrowimage', undef], # ignored for compatibility with BrowseEntry
                      -autolimitheight => ['PASSIVE', 'autolimitheight', 'autolimitheight', undef], # ignored for compatibility with BrowseEntry
                      -autolistwidth  => ['PASSIVE', 'autolimitwidth', 'autolimitwidth', undef],    # ignored for compatibility with BrowseEntry
                      -browsecmd       => ['CALLBACK', 'browsecmd',  'browsecmd',  undef], 
                      -browse2cmd      => ['CALLBACK', 'browse2cmd', 'browse2cmd', undef], 
                      -buttontakefocus => -takefocus, 
                      -choices         => '-values',
		      -choices      =>    [ qw/METHOD choices     choices/, undef ],
                      -colorstate      => ['PASSIVE', 'colorstate', 'colorstate', undef], # ignored for compatibility with BrowseEntry
                      -listcmd         => -postcommand, 
                      -listheight      => -height, 
                      -listwidth       => ['PASSIVE', 'listwidth', 'listwidth', undef], # ignored for compatibility with BrowseEntry 
                                                                                        # (combobox listbox is always the same as -width, 
                                                                                        #   so not needed)
                      -variable        => -textvariable
                      
    );
    
    # Create callback to emulate -browsecmd and -browsecmd2 options
    $cw->bind('<<ComboboxSelected>>', [$cw, '_ComboboxSelected']);

    
      
}

###########################################################################

#----------------------------------------------
# Sub called when -choices option changed
#
#  This just translates the -choices call to -values on the host ttk widget, but if
#   -autosetwidth is set, then we also change the width, if needed
#
sub choices{
	my ($cw, $choices) = @_;


	if(! defined($choices)){ # Handle case where $widget->cget(-choices) is called

		return $cw->call($cw, 'cget', '-values'); # Call tile object directly
		
	}
	
        return if ( !defined($choices) || (ref($choices) ne 'ARRAY')) ; # don't do anything if not defined

                
        $cw->call($cw, 'configure', '-values', $choices);
}


#########################################################################
# Sub called when choice selected. This fires off any browsecmd callbacks that have been
#   stored
#
#

sub _ComboboxSelected{
        my $self = shift;
        my $path = shift;
        
        # Check for browsecmd or browsecmd2 being set
        my $browsecmd = $self->cget(-browsecmd);
        my $browsecmd2 = $self->cget(-browse2cmd);
        if( defined($browsecmd) && $browsecmd->isa('Tcl::Tk::Callback')){
                my $sel = $self->get(); # Get current selection
                $browsecmd->BindCall($self, $sel);
        }
        elsif( defined($browsecmd2) && $browsecmd2->isa('Tcl::Tk::Callback')){
                my $index = $self->current(); # Get current index
                $browsecmd2->BindCall($self, $index);
        }
       
}

###########################################
# Wrapper for the insert method. For compatibility with BrowseEntry, insert works on the choices, and not just
#  what is in the entry widget
sub insert {
    my $w = shift;
    my $index = shift;
    my @insertValues = @_;
    my @choices = $w->cget('-values');
    $index = $#choices if( $index eq 'end' ); # get the last index if insert is 'end';
    
    # Add insertvalues to choices and update widget
    splice @choices, $index, 0, @insertValues;
    
    $w->configure('-values' => \@choices);
    
}

# Wrapper for the delete method. For compatibility with BrowseEntry, delete works on the choices, and not just
#  what is in the entry widget
sub delete {
    my $w = shift;
    my ($start, $stop) = @_;
    my @choices = $w->cget('-values'); 
    
    $stop = $start if( !defined($start)); # Take care of case where $stop not supplied
    
    # Change any 'end' in the indexes to actual number
    foreach my $entry($start, $stop){
            $entry = $#choices if($entry eq 'end');
    }
    
    my $count = $stop - $start + 1;
    
    # Update Choices
    splice @choices, $start, $count;
    
    $w->configure('-values' => \@choices);

}


1;

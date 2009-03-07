

package Tcl::Tk::Widget::TableMatrix;

###########################################################
# Emulation of the perl/tk Tablematrix widget using Tcl::Tk
###########################################################

@Tcl::Tk::Widget::TableMatrix::ISA = (qw / Tcl::Tk::Derived Tcl::Tk::Widget/);

use strict;

use Carp;

Construct Tcl::Tk::Widget 'TableMatrix';

# Predeclare methods like 'borderMark', 'clearCache', so they don't have to be autoloaded
use Tcl::Tk::Submethods ( 'border'   => [qw(mark dragto)],
		     'clear'    => [qw(cache sizes tags all)],
		     'delete'   => [qw(active cols rows)],
		     'insert'   => [qw(active cols rows)],
		     'scan'     => [qw(mark dragto)],
		     'selection'=> [qw(anchor clear includes set)],
		     'tag'      => [qw(cell cget col configure delete exists
				     includes names row raise lower)],
		     'window'   => [qw(cget configure delete move names)],
		     'xview'  => [qw(moveto scroll)],
		     'yview'  => [qw(moveto scroll)],
			);

# 
sub colWidth{
        my $self = shift;
        $self->interp->invoke($self, 'width', @_);
}
sub rowHeight{
        my $self = shift;
        $self->interp->invoke($self, 'height', @_);
}


sub Populate {
    my( $cw, $args ) = @_;

    $cw->SUPER::Populate( $args );
    
    # Create attributes:
    #   Name of the Tcl variable used to store the -variable data
    $cw->{varTclName} = "::perl:_variable".$cw;
    
    

    $cw->ConfigSpecs(
        -variable => ['METHOD', 'variable', 'variable', undef], # Special processing for the -variable option
        'DEFAULT' => ['SELF']                                   # Other variables sent to the base/container widget
    );
    
    # Setup action when the window is destroyed to delete any variable trace we setup

    $cw->OnDestroy(
                [$cw, '_deleteVarTrace']
                );

}

# Container widget for TableMatrix is a TkTable
sub containerName{
        return 'Tktable';
}


#----------------------------------------------
# Sub called when -arrayVar option changed
#
sub variable{
	my ($cw, $variable) = @_;

	if(! defined($variable)){ # Handle case where $widget->cget(-$option) is called

		return $cw->{Configure}{-variable}
		
	}

        croak("Error in TableMatrix: Supplied -variable is not a hash ref") unless( ref($variable) eq 'HASH');
        
        my $varTclName  = $cw->{varTclName}; 
        my $varTraceCmd = $cw->{varTraceCmd};
        my $interp = $cw->interp;

        if( !defined( $cw->{varTraceCmd} )){ # Delete the old trace, if it exists
                
                
                # Create Tcl command name for the trace command (based off the tcl variable name)
                $varTraceCmd = $cw->{varTraceCmd} = $varTclName."_traceCmd"; 
                
                # Create destroy action to delete the trace command
                 
        } 
        else{   
                # varTracecmd is defined, remove old trace
                $interp->Eval("trace remove variable $varTclName read $varTraceCmd");
                $interp->DeleteCommand($varTraceCmd); # Get rid of command from tcl land
                
        }
                
        
        # Create trace from the tcl variable (named $varTclName) to the supplied perl variable
        #   Any reads from Tcl-Land will cause the $varTraceCmd to be read

        my $readCmd = sub{
                my @args = @_;
                my ($dummy, $interp, $procName, $tclName, $index, $op) = @_;
                #print "Args = ".join(", ", @args)."\n";
                $interp->invoke('set', $tclName."($index)", $variable->{$index});
        };
        
        
        $interp->CreateCommand($varTraceCmd, $readCmd);
        $interp->Eval("trace add variable $varTclName read $varTraceCmd");
        
        # Call the base tktable widget with the name of the tcl variable, to signal that it needs to 
        # update its display
        $interp->invoke($cw, 'configure', -variable, $varTclName);
}
        
###################################################
# Sub called when window destroyed (setup thru the OnDestroy call) that deletes
#   the variable trace
sub _deleteVarTrace{
        my $self = shift;
        
        #print "In destroy\n";
        my $varTclName  = $self->{varTclName}; 
        my $varTraceCmd = $self->{varTraceCmd};

        return unless defined($varTraceCmd); # Don't do anything if a trace hasn't been defined
        
        # Get rid of the variable trace
        eval{ # Error protection, in-case the progame is dieing and it is too late to do this
                my $interp = $self->interp;
                
                $interp->Eval("trace remove variable $varTclName read $varTraceCmd");
                $interp->DeleteCommand($varTraceCmd); # Get rid of command from tcl land
                #print "trace removed\n";
        }
}

        

1;



package Tcl::Tk::Widget::Canvas;

# Simple Canvas package.
#  This is here just so widgets can subclass from a canvas before actually creating a canvas
# Also to provide some compatibility functions with perl/tk
@Tcl::Tk::Widget::Canvas::ISA = ('Tcl::Tk::Widget');


## Wrapper for the canvas index command.
##  This translates indexes that are array ref form (e.g. [10,20]) into tcl index form 
##     (e.g. '@10,20'), for compatibility with perl/tk
sub index{
        my $self  = shift;
        my $id    = shift;
        my $index = shift;
        
        if( ref($index) and ref($index) eq 'ARRAY'){ 
                $index = '@'.join(",",@$index);
        }
        
        $self->interp->icall($self->path, 'index', $id, $index);
}
1;


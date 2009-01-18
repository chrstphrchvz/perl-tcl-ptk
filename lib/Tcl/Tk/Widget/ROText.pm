# Copyright (c) 1995-2003 Nick Ing-Simmons. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Modified 2008 for inclusion into the Tcl::Tk package

package Tcl::Tk::Widget::ROText;

use base  qw(Tcl::Tk::Derived Tcl::Tk::Widget::Text);

Construct Tcl::Tk::Widget 'ROText';

sub clipEvents
{
 return qw[Copy];
}

sub ClassInit
{
 my ($class,$mw) = @_;
 
 $class->SUPER::ClassInit($mw);
 
 my $cb  = $mw->bind($class,'<Next>');
 $mw->bind($class,'<space>',$cb) if (defined $cb);
 $cb  = $mw->bind($class,'<Prior>');
 $mw->bind($class,'<BackSpace>',$cb) if (defined $cb);
 
 # Hijack the paste binding to do nothing
 $mw->bind($class, '<<Paste>>', sub{ 
        #print "I am pasting\n";
        Tcl::Tk::break();
 });
 
 return $val;
}

sub Populate {
    my($self,$args) = @_;
    $self->SUPER::Populate($args);
    
    my $m = $self->menu();
 
    $m = $self->menu->entrycget($self->menu->index('Search'), '-menu');
    $m->delete($m->index('Replace'));
}

#sub Tk::Widget::ScrlROText { shift->Scrolled('ROText' => @_) }

# Overridden method, does nothing for ROText
sub Backspace
{
}

# Overridden method, does nothing for ROText
sub Delete
{
}

# Overridden method, does nothing for ROText
sub InsertKeypress
{
}

1;

__END__


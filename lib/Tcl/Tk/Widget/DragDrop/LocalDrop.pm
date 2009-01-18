package Tcl::Tk::Widget::DragDrop::LocalDrop;
use strict;

use base qw(Tcl::Tk::Widget::DragDrop::Rect);
require Tcl::Tk::Widget::DragDrop;

my @toplevels;

#Tcl::Tk::Widget::DragDrop->Type('Local');
Tcl::Tk::Widget::DragDrop::Common::Type('Tcl::Tk::Widget::DragDrop', 'Local');

sub XY
{
 my ($site,$event) = @_;
 return ($event->X - $site->X,$event->Y - $site->Y);
}

sub Apply
{
 my $site = shift;
 my $name = shift;
 my $cb   = $site->{$name};
 if ($cb)
  {
   my $event = shift;
   $cb->Call(@_,$site->XY($event));
  }
}

sub Drop
{
 my ($site,$token,$seln,$event) = @_;
 $site->Apply(-dropcommand => $event, $seln);
 $site->Apply(-entercommand => $event, 0);
 $token->Done;
}

sub Enter
{
 my ($site,$token,$event) = @_;
 $token->AcceptDrop;
 $site->Apply(-entercommand => $event, 1);
}

sub Leave
{
 my ($site,$token,$event) = @_;
 $token->RejectDrop;
 $site->Apply(-entercommand => $event, 0);
}

sub Motion
{
 my ($site,$token,$event) = @_;
 $site->Apply(-motioncommand => $event);
}


1;

__END__

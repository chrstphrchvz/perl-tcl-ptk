# Copyright (c) 1995-2004 Nick Ing-Simmons. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

# Modified for inclusion into Tcl::pTk 10/20/08

package Tcl::pTk::After;

our ($VERSION) = ('0.84');

use Carp;

sub _cancelAll
{
 my $w = shift;
 my $h = delete $w->{_After_};
 foreach my $obj (values %$h)
  {
   #print "Auto cancel ".$obj->[1]." for ".$obj->[0]->PathName." Window = $w\n";
   $obj->cancel;
   bless $obj,"Tcl::pTk::After::Cancelled";
  }
}

sub Tcl::pTk::After::Cancelled::once { }
sub Tcl::pTk::After::Cancelled::repeat { }

sub submit
{
 my $obj     = shift;
 my $w       = $obj->[0];
 my $id      = $obj->[1];
 my $t       = $obj->[2];
 my $method  = $obj->[3];
 delete($w->{_After_}{$id}) if (defined $id);
 $id  = $w->interp->Tcl::pTk::after($t,sub{$obj->$method});
 unless (exists $w->{_After_})
  {
   $w->{_After_} = {};
   $w->OnDestroy([\&_cancelAll, $w]);
  }
 #print "Tcl::pTk::After::submit setting after $id to $obj, window = $w\n";
 $w->{_After_}{$id} = $obj;
 $obj->[1] = $id;
 return $obj;
}

sub DESTROY
{
 my $obj = shift;
 $obj->cancel;
 undef $obj->[0];
 undef $obj->[4];
}

sub new
{
 my ($class,$w,$t,$method,@cb) = @_;
 my $cb    = (@cb == 1) ? shift(@cb) : [@cb];
 my $obj   = bless [$w,undef,$t,$method,Tcl::pTk::Callback->new($cb)],$class;
 return $obj->submit;
}

sub cancel
{
 my $obj = shift;
 my $id  = $obj->[1];
 my $w   = $obj->[0];
 return unless( defined $w);
 if ($id)
  {
   my $interp = $w->interp;
   $interp->icall('after', 'cancel'=> $id) if( defined($interp) );
   #print "Tcl::pTk::After::cancel: deleting $id";
   delete $w->{_After_}{$id} if exists $w->{_After_};
   $obj->[1] = undef;
  }
 return $obj;
}

sub repeat
{
 my $obj = shift;
 $obj->submit;
 local $Tcl::pTk::widget = $obj->[0];
 $obj->[4]->Call;
}

sub once
{
 my $obj = shift;
 my $w   = $obj->[0];
 my $id  = $obj->[1];
 delete $w->{_After_}{$id};
 local $Tcl::pTk::widget = $w;
 $obj->[4]->Call;
}

sub time {
    my $obj = shift;
    my $delay = shift;
    if (defined $delay) {
	$obj->cancel if $delay == 0;
	$obj->[2] = $delay;
    }
    $obj->[2];
}

1;
__END__


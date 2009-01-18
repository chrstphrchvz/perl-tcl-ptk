# Copyright (c) 1995-2003 Nick Ing-Simmons. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Tcl::Tk::Widget::LabEntry;


use base  qw(Tcl::Tk::Widget::Frame);
#use Tk::widgets qw(Frame Label Entry);

Construct Tcl::Tk::Widget 'LabEntry';

sub Populate
{
 # LabeledEntry constructor.
 #
 my($cw, $args) = @_;
 $cw->SUPER::Populate($args);
 # Advertised subwidgets:  entry.
 my $e = $cw->Entry();
 $e->pack('-expand' => 1, '-fill' => 'both');
 $cw->Advertise('entry' => $e );
 $cw->ConfigSpecs(DEFAULT => [$e]);
 $cw->Delegates(DEFAULT => $e);
 $cw->AddScrollbars($e) if (exists $args->{-scrollbars});
}

1;

# Copyright (c) 1995-2003 Nick Ing-Simmons. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Tcl::pTk::LabEntry;

our ($VERSION) = ('1.04');

use base  qw(Tcl::pTk::Frame);
#use Tk::widgets qw(Frame Label Entry);

Construct Tcl::pTk::Widget 'LabEntry';

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

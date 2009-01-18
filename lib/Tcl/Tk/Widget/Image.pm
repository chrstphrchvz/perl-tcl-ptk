# Copyright (c) 1995-2003 Nick Ing-Simmons. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
package Tcl::Tk::Widget::Image;

# This module does for images what Tk::Widget does for widgets:
# provides a base class for them to inherit from.

use base qw(Tcl::Tk::Widget Tcl::Tk::Derived);


sub new
{
 my $package = shift;
 my $widget  = shift;
 $package->InitClass($widget);
 my $int = $widget->interp();
 $int->pkg_require('Img');
 

 my $leaf = $package->Tk_image;
 my $obj = $int->declare_widget($widget->call('image','create', $leaf, @_),
         $package);
 return bless $obj,$package;
}

sub Install
{
 # Dynamically loaded image types can install standard images here
 my ($class,$mw) = @_;
}

sub ClassInit
{
 # Carry out class bindings (or whatever)
 my ($package,$mw) = @_;
 return $package;
}

require Tcl::Tk::Submethods;

Direct Tcl::Tk::Submethods ('image' => [qw(delete width height type)]);

sub Tcl::Tk::Widget::imageNames
{
 my $w = shift;
 my @names =  $w->call('image', 'names');
 
 # Go thru each image names and turn into an object;
 my @imageObj;
 foreach my $name(@names){
         my $type = $w->call('image', 'type', $name);
         $type = ucfirst($type);
         my $package = "Tcl::Tk::Widget::$type";
         my $obj = $w->interp->declare_widget($name, $package);

         push @imageObj, $obj;
 }
 return @imageObj;
}

sub Tcl::Tk::Widget::imageTypes
{
 my $w = shift;
 map("\u$_",$w->call('image','types',@_));
}

sub Construct
{
 my ($base,$name) = @_;
 my $class = (caller(0))[0];

 # Hack for broken ->isa in perl5.6.0
 delete ${"$class\::"}{'::ISA::CACHE::'} if $] == 5.006;

 *{"Tcl::Tk::Widget::$name"}  = sub { $class->new(@_) };
}

# This is here to prevent AUTOLOAD trying to find it.
sub DESTROY
{
 my $i = shift;
 # maybe do image delete ???
}


1;

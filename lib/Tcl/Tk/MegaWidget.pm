#
# Proof-of-concept Megawidget support for Tcl::Tk

package Tcl::Tk::Widget;

use Carp;
use Tcl::Tk::Configure;

# For debugging, we use Sub::Name to name anonymous subs, this makes tracing the program
#   much easier (using perl -d:DProf or other tools)
our ($DEBUG);
$DEBUG =1;
if($DEBUG){
        require Sub::Name;
        import Sub::Name;
}
#use Sub::Name;

########## Methods Originally in Tk::Widget #########

# This "Constructs" a creation method for megawidgets and derived widgets
sub Construct
{
 my ($base,$name) = @_;
 my $class = (caller(0))[0];
 no strict 'refs';

 # Hack for broken ->isa in perl5.6.0
 delete ${"$class\::"}{'::ISA::CACHE::'} if $] == 5.006;

 # Pre ->isa scheme
 *{$base.'::Is'.$name}  = \&False;
 *{$class.'::Is'.$name} = \&True;

 
 # DelegateFor  trickyness is to allow Frames and other derived things
 # to force creation in a delegate e.g. a ScrlText with embeded windows
 # need those windows to be children of the Text to get clipping right
 # and not of the Frame which contains the Text and the scrollbars.
 my $sub;
 *{$base.'::'."$name"}  = $sub =  sub { $class->new(shift->DelegateFor('Construct'),@_) };
 subname($base.'::'."$name", $sub) if($DEBUG);
}


sub DelegateFor
{
 my ($w,$method) = @_;
 while(exists $w->{'Delegates'})
  {
   my $delegate = $w->{'Delegates'};
   my $widget = $delegate->{$method};
   $widget = $delegate->{DEFAULT} unless (defined $widget);
   $widget = $w->Subwidget($widget) if (defined $widget && !ref $widget);
   last unless (defined $widget);
   last if $widget == $w;
   $w = $widget;
  }
 return $w;
}

sub Delegates
{
 my $cw = shift;
 my $specs = $cw->TkHash('Delegates');
 while (@_)
  {
   my $key = shift;
   my $val = shift;
   $specs->{$key} = $val;
  }
 return $specs;
}

######### new method copied from Tk::Widget #####
sub new
{
 local $SIG{'__DIE__'} = \&Carp::croak;
 my $package = shift;
 my $parent  = shift;
  
 $package->InitClass($parent);
 $parent->BackTrace("Odd number of args to $package->new(...)") unless ((@_ % 2) == 0);
 my @args  = @_;
 my %args  = @args;
 my @createArgs  = $package->CreateArgs($parent,\%args);
 
 # Get the container widget name using the ContainerName method (present in Frame and Toplevel widgets)
 #print "looking up container for package '$package'\n";
 my $containerWidget = $package->containerName(); 
 #print "container for package '$package' is $containerWidget\n";
 
 # Check for basic widget (i.e. non-derived) There is no need to call configure twice
 #   on these types of widgets. So all args are fed to it at creation time
 my $basicWidget = $package->basicWidget($containerWidget, %args);

 if( $basicWidget && ! @createArgs ){
         @createArgs = (@createArgs, %args);
         %args = ();
 }
 
 my $containerSub = "Tcl::Tk::$containerWidget"; # Raw sub to create the container (no delegation)
 my $obj = eval { $parent->$containerSub(@createArgs)};
 confess $@ if $@;
 unless (ref $obj)
  {
   die "No value from parent->$containerWidget" unless defined $obj;
  }
 bless $obj, $package;
 $obj->SetBindtags;
 my $notice = $parent->can('NoticeChild');
 $parent->$notice($obj,\%args) if $notice;
 $obj->InitObject(\%args);
# ASkludge(\%args,1);
 $obj->configure(%args) if (%args);
# ASkludge(\%args,0);
 return $obj;
}

# Class method that returns 1 if the current widget is a "basic" widget, i.e. a 
#   width that is directly mapped to a widget in Tcl/Tk. The Button, Frame, 
#     checkbutton, etc widget are examples of "basic" widgets
sub basicWidget{
        my $package = shift;
        my $containerWidget = shift;
  
        # Widget is a "basic" widget if it's container widget is the same as its
        #   package name like so
        return 1 if( "Tcl::Tk::Widget::$containerWidget" eq $package);
        return 0;
}


# This is the cleanup sub that gets called when a widget is destroyed
#  (before the <Destroy> event is fired)
#   This sub gets called from the widget_deletion_watcher in Widget.pm
#
sub _Destroyed
{
 my $w = shift;
 my $a = delete $w->{'_Destroy_'};
 if (ref($a))
  {
   while (@$a)
    {
     my $ent = pop(@$a);
     if (ref $ent)
      {
       eval {local $SIG{'__DIE__'}; $ent->Call };
      }
     else
      {
       delete $w->{$ent};
      }
    }
  }
}

# Sub to add and entry to the list of items that will get deleted when a widget
#   is destroyed. This will happen before the <Destroy> event is fired.
sub _OnDestroy
{
 my $w = shift;
 $w->{'_Destroy_'} = [] unless (exists $w->{'_Destroy_'});
 push(@{$w->{'_Destroy_'}},@_);
}

# Public method to add something to be performed during widget destruction (before
#  the <Destroy> event gets fired).
sub OnDestroy
{
 my $w = shift;
 $w->_OnDestroy(Tcl::Tk::Callback->new(@_));
}

sub TkHash
{
 my ($w,$key) = @_;
 return $w->{$key} if exists $w->{$key};
 my $hash = $w->{$key} = {};
 $w->_OnDestroy($key);
 return $hash;
}

sub privateData
{
 my $w = shift;
 my $p = shift || caller;
 $w->{$p} ||= {};
}
# Stub for Populate, overridden in megawidgets
sub Populate
{
 my ($cw,$args) = @_;
}


sub CreateOptions
{
 return ('Name', '-class'); # Name and -class options, if present always needs to be supplied at creation time
}

sub CreateArgs
{
 my ($package,$parent,$args) = @_;
 # Remove from hash %$args any configure-like
 # options which only apply at create time (e.g. -colormap for Frame),
 # or which may as well be applied right away
 # return these as a list of -key => value pairs
 # Augment same hash with default values for missing mandatory options,
 # allthough this can be done later in InitObject.

 # Note that the behaviour for the -class option has been changed
 #   for Tcl::Tk. Perl/Tk would set the -class option for every widget, because
 #   perl/tk had a special version of Tk_ConfigureWidget that
 #   allowed -class to be passed to any widget.
 #   This was a perl/tk specific hack to the perl/tk c-code.
 #   Tcl/Tk only allows -class in calls to the Frame and Toplevel widget, and not to other widgets.
 #  
 
 # Honour -class => if present
 # allow -class to be passed to any widget.
 my @result = ();
 my $class = delete $args->{'-class'};
 ($class) = $package =~ /([A-Z][A-Z0-9_]*)$/i unless (defined $class);
 
 # Using the class option is only valid for Toplevel and Frame
 #  widgets for Tcl/Tk
 my $classOk; 
 $classOk = $package->isa('Tcl::Tk::Widget::Frame') || 
            $package->isa('Tcl::Tk::Widget::Toplevel');
 
 @result = (-class => "\u$class") if (defined($class) && $classOk);
  foreach my $opt ($package->CreateOptions)
  {
   unshift (@result, $opt => delete $args->{$opt}) if exists $args->{$opt};
  }
 return @result;
}

sub AddBindTag
{
 my ($w,$tag) = @_;
 my $t;
 my @tags = $w->bindtags;
 foreach $t (@tags)
  {
   return if $t eq $tag;
  }
 $w->bindtags([@tags,$tag]);
}

sub Callback
{
 my $w = shift;
 my $name = shift;
 my $cb = $w->cget($name);
 if (defined $cb)
  {
   return $cb->Call(@_) if (ref $cb);
   return $w->$cb(@_);
  }
 return (wantarray) ? () : undef;
}

# Bindtags from original Tk::Widget
sub SetBindtags
{
 my ($obj) = @_;
 
 # We deviate from perltk and create an extra bindtag
 #  for the tcl class name of our container widget
 #   This is necessary because we can't support the -class option when
 #    the container widget was created, like perltk does.
 
 # Note that normal widget calls are inlined here for speed
 # my $path = $obj->path;   # Normal widget call
 my $path = $obj->{winID};  # Inlined ->path call
 
 # my $int = $obj->interp;            # Normal widget call
 my $int = $Tcl::Tk::Wint->{ $path }; # Inlined ->interp call
 
 my $tclClass = $int->invoke('winfo', 'class', $path); # Get the tcl class
 
 # Inlined toplevel call
 my $toplevel = $int->invoke('winfo', 'toplevel', $path);

 # $obj->bindtags([ref($obj),$tclClass, $obj,$obj->toplevel,'all']);  # Normal bindtags call
 ## Inlined bindtags call
 $int->invoke('bindtags', $path, [ref($obj),$tclClass, $path, $toplevel, 'all']);
 
}

#################### Methods Originally in Tk ##########################


# Simplified version of Backtrace in Tk.pm.
# XXX Needs to be updated for better error reporting
sub BackTrace{
        my $cw = shift;
        my $message = shift;
        die $message."\n";
}
        
# Simplfied IsWidget method. This was originaly in Tk.xs in the pTk distribution
#   we just do a simple isa call
sub IsWidget{
        my $cw = shift;
        return $cw->isa("Tcl::Tk::Widget");
}
        
# a wrapper on eval which turns off user $SIG{__DIE__}
sub Tcl::Tk::catch (&)
{
 my $sub = shift;
 eval {local $SIG{'__DIE__'}; &$sub };
}

######### This was copied from Tk::Scrollbar #######
### It is needed for some of the standard Tk megawidgets (like BrowseEntry) to work
###
sub Tcl::Tk::Widget::Scrollbar::Needed
{
 my ($sb) = @_;
 my @val = $sb->get;

 # Old Scrollbars return a 4-element list the first time get is called, so
 #   the following ensures that Needed returns 1 for the first time it is called
 return 1 unless (@val == 2);
 return 1 if $val[0] != 0.0;
 return 1 if $val[1] != 1.0;
 return 0;
}

## Copy of above for ttkScrollbar. Needed for using Tile scrollbar with the 'Scrolled' widget
sub Tcl::Tk::Widget::ttkScrollbar::Needed
{
 my ($sb) = @_;
 my @val = $sb->get;
 
 # 
 # For compatibility with old Scrollbars, which return 1 the first time needed is called on them,
 #  we setup a hash value so that 1 will be returned the first time Needed is called on a scrollbar
 if( !defined($sb->{_sbNeededFirstTime}) ){
         $sb->{_sbNeededFirstTime} = 1;
         return 1;
 }
 return 1 unless (@val == 2);
 return 1 if $val[0] != 0.0;
 return 1 if $val[1] != 1.0;
 return 0;
}

1;

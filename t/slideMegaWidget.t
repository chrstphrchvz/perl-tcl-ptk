# Test Case for a megawidget

use warnings;
use strict;

#$Tk::SlideSwitch::VERSION = '1.1';

use Test;
plan tests => 2;

package Tcl::pTk::SlideSwitch;

use Tcl::pTk;
use Tcl::pTk::MegaWidget;
use Tcl::pTk::TextUndo;

#use Tk;
#use Tk::TextUndo;

use base qw/Tcl::pTk::Frame/;
#use base qw/Tk::Frame/;

Construct Tcl::pTk::Widget 'SlideSwitch';
#Construct Tk::Widget 'SlideSwitch';

sub Populate {

    my($self, $args) = @_;

    $self->SUPER::Populate($args);

    
    my $mw = $self->MainWindow();
    
    
    my $ll = $self->Label->pack(-side => 'left');
    my $sl = $self->Scale->pack(-side => 'left');
    my $rl = $self->Label->pack(-side => 'left');
    
    # This is not part of the megawidget, just a test to see if Component works
    my $dummy = $self->Component('TextUndo', 'undo');
    my $dummy2 = $self->Component('Frame', 'Menubar', -class => 'Menubar');
    
    $self->ConfigSpecs(
        -command      => [$sl,        qw/command      Command            /],  
        -from         => [$sl,        qw/from         From              0/],
        -highlightthickness => [$sl,
            qw/highlightThickness HighlightThickness                    0/],
        -length       => [$sl,        qw/length       Length           30/],
        -llabel       => [qw/METHOD      llabel       Llabel             /],
        -orient       => [$sl,        qw/orient       Orient   horizontal/],
        -rlabel       => [qw/METHOD      rlabel       Rlabel             /],  
        -showvalue    => [$sl,        qw/showValue    ShowValue         0/],
        -sliderlength => [$sl,        qw/sliderLength SliderLength     15/],
        -sliderrelief => [$sl,        qw/sliderRelief SliderRelief raised/],
        -to           => [$sl,        qw/to           To                1/],
        -troughcolor  => [$sl,        qw/troughColor  TroughColor        /],
        -width        => [$sl,        qw/width        Width             8/],
        -variable     => [$sl,        qw/variable     Variable           /],
        'DEFAULT'     => [$ll, $rl],
    );

    $self->{ll} = $ll;
    $self->{sl} = $sl;
    $self->{rl} = $rl;

    $self->bind('<Configure>' => sub {
	my ($self) = @_;
	my $orient = $self->cget(-orient);
	return if $orient eq 'horizontal';
	my ($ll, $sl, $rl) = ($self->{ll}, $self->{sl}, $self->{rl});
	$ll->packForget;
	$sl->packForget;
	$rl->packForget;
	$ll->pack;
	$sl->pack;
	$rl->pack;
    });

} # end Populate

# Private methods and subroutines.

sub llabel {
    my ($self, $args) = @_;
    $self->{ll}->configure(@$args);
} # end llabel

sub rlabel {
    my ($self, $args) = @_;
    $self->{rl}->configure(@$args);
} # end rlabel

1;

##############################################################################

package main;

use Tcl::pTk;
# use Tk;


my $TOP = MainWindow->new();



    my $mw = $TOP;

    my $sl = $mw->SlideSwitch(
        -bg          => 'gray',
        -orient      => 'horizontal',
        -command     => sub {print "Switch value is '".join("', '", @_)."'\n"},
        -llabel      => [-text => 'OFF', -foreground => 'blue'],
        -rlabel      => [-text => 'ON',  -foreground => 'blue'],
        -troughcolor => 'tan',
    )->pack(qw/-side left -expand 1/);


# Check to make sure the classname is properly assigned
my $class = $sl->class;
ok($class, 'SlideSwitch', "SlideSwitch Classname Check");
    
ok(1,1, "Slide Megawidget");

$TOP->idletasks;
MainLoop if (@ARGV);

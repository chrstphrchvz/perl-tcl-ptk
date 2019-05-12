# menus.pl

use warnings;
use strict;

use subs qw/menus_error/;
use vars qw/$TOP/;

#sub Tcl::TRACE_SHOWCODE(){1}
#$Tcl::pTk::DEBUG = 1;
use Data::Dump qw(dump);
use Hook::LexWrap;

sub Eval_pre {
    print STDERR "\nEval(".dump(@_).")"
        ."\nat @{[caller]}\n"
}
sub Eval_post {
    my $res = $_[-1];
    print STDERR "Result of Eval() = ".
        (ref($res) eq 'ARRAY'
            ? dump(@$res)
            : $res)
        ."\n"
}
sub invoke_pre {
    print STDERR "\ninvoke(".dump(@_).")"
        ."\nat @{[caller]}\n"
}
sub invoke_post {
    my $res = $_[-1];
    print STDERR "Result of invoke() = ".
        (ref($res) eq 'ARRAY'
            ? dump(@$res)
            : $res)
        ."\n"
}
sub icall_pre {
    print STDERR "\nicall(".dump(@_).")"
        ."\nat @{[caller]}\n"
}
sub icall_post {
    my $res = $_[-1];
    print STDERR "Result of icall() = ".
        (ref($res) eq 'ARRAY'
            ? dump(@$res)
            : $res)
        ."\n"
}


sub menus {

    # This demonstration script creates a window with a bunch of menus
    # and cascaded menus using a menubar.  A <<MenuSelect>> virtual event
    # tracks the active menu item.

    my ($demo) = @_;
    $TOP = $MW->WidgetDemo(
        -name     => $demo,
        -text     => ['', -wraplength => '5i'],	
        -title    => 'Menu Demonstration',
        -iconname => 'menus',
    );

    my $ws = $TOP->windowingsystem;

    my $text = ($ws eq 'classic' or $ws eq 'aqua') ?
        'This window contains a menubar with cascaded menus.  You can invoke entries with an accelerator by typing Command+x, where "x" is the character next to the command key symbol. The rightmost menu can be torn off into a palette by dragging outside of its bounds and releasing the mouse.' :
        'This window contains a menubar with cascaded menus.  You can post a menu from the keyboard by typing Alt+x, where "x" is the character underlined on the menu.  You can then traverse among the menus using the arrow keys.  When a menu is posted, you can invoke the current entry by typing space, or you can invoke any entry by typing its underlined character.  If a menu entry has an accelerator, you can invoke the entry without posting the menu just by typing the accelerator. The rightmost menu can be torn off into a palette by selecting the first item in the menu.';

    $TOP->configure(-text => $text);

    my $toplevel = $TOP->toplevel; # get $TOP's Toplevel widget reference
    my $menubar = $toplevel->Menu(-type => 'menubar', -tearoff => 0);
    $toplevel->configure(-menu => $menubar);

    my $modifier;
    if ( $ws eq 'classic' or $ws eq 'aqua') {
	$modifier = 'Command';
    } elsif ($Tcl::pTk::platform eq 'windows') {
	$modifier = 'Control';
    } else {
	$modifier = 'Meta';
    }

    my $lexical_Eval = wrap 'Tcl::Eval', pre => \&Eval_pre, post => \&Eval_post;
    my $lexical_invoke = wrap 'Tcl::invoke', pre => \&invoke_pre, post => \&invoke_post;
    my $lexical_icall = wrap 'Tcl::icall', pre => \&icall_pre, post => \&icall_post;

    my $label;
    my $c = $menubar->cascade(-label => '~Cascades', -tearoff => 0);
    $c->command(
        -label       => 'Print hello',
        -command     => sub {print "Hello\n"},
	-accelerator => "$modifier+H",
        -underline   => 6,
    );
    $TOP->bind("<$modifier-h>" => sub {print "Hello\n"});
    $c->command(
        -label       => 'Print goodbye',
        -command     => sub {print "Goodbye\n"},
	-accelerator => "$modifier+G",
        -underline   => 6,
    );
    $TOP->bind("<$modifier-g>" => sub {print "Goodbye\n"});
    my $cc = $c->cascade(-label => '~Check buttons', -tearoff => 0);

    $cc->checkbutton(-label => 'Oil checked', -variable => \$OIL);
    $cc->checkbutton(-label => 'Transmission checked', -variable => \$TRANS);
    $cc->checkbutton(-label => 'Brakes checked', -variable => \$BRAKES);
    $cc->checkbutton(-label => 'Lights checked', -variable => \$LIGHTS);
    $cc->separator;
    $cc->command(
        -label => 'See current values',
	-command => [\&see_vars, $MW, [
                                       ['oil',     \$OIL],
                                       ['trans',   \$TRANS],
                                       ['brakes',  \$BRAKES],
                                       ['lights',  \$LIGHTS],
                                      ],
                    ],
    );
    my $cc_menu = $cc->cget(-menu);
    $cc_menu->invoke(1);
    $cc_menu->invoke(3);

    my $rc = $c->cascade(-label => '~Radio buttons', -tearoff => 0);

    foreach $label (qw/10 14 18 24 32/) {
	$rc->radiobutton(
            -label    => "$label point",
            -variable => \$POINT_SIZE,
            -value    => $label,
        );
    }
    $rc->separator;
    foreach $label (qw/Roman Bold Italic/) {
	$rc->radiobutton(
            -label    => $label,
            -variable => \$FONT_STYLE,
            -value    => $label,
        );
    }
    $rc->separator;
    $rc->command(
        -label => 'See current values',
	-command => [\&see_vars, $MW, [
                                      ['point size', \$POINT_SIZE],
                                      ['font style', \$FONT_STYLE],
                                     ],
                    ],
    );
    my $rc_menu = $rc->cget(-menu);
    $rc_menu->invoke(1);
    $rc_menu->invoke(7);
    

} # end menus

sub menus_error {

    # Generate a background error, which may even be displayed in a window if
    # using ErrorDialog.

    my($msg) = @_;

    $msg = "This is just a demo: no action has been defined for \"$msg\".";
    $TOP->BackTrace($msg);

} # end menus_error


1;

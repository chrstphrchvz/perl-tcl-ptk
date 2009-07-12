package Tcl::Tk::Widget::Menubutton;

# Simple Menu package.


use Tcl::Tk::Widget();

@Tcl::Tk::Widget::Menubutton::ISA = qw(Tcl::Tk::Widget);

Tcl::Tk::Widget->Construct('Menubutton');



# Method to return the containerName of the widget
#   Any subclasses of this widget can call containerName to get the correct
#   container widget for the subwidget
sub containerName{
        return 'Menubutton';
}

################# Raw Widget Creation Method #####
## Created in Tcl::Tk space
##  For other auto-wrapped widgets (like Label, Entry) this would be auto-created
##  by the declareAutoWidget method in Tcl::Tk::Widget
sub Tcl::Tk::Menubutton {
    my $self = shift; # this will be a parent widget for newer menubutton
    my $int = $self->interp;
    my $w    = $self->w_uniq("mb"); # create uniq pref's widget id
    my %args = @_;
    my $mcnt = '01';
    my $mis = delete $args{'-menuitems'};
    my $tearoff = delete $args{'-tearoff'};
    $args{'-state'} = delete $args{state} if exists $args{state};
    $args{'-text'} = delete $args{-label} if exists $args{-label};

    Tcl::Tk::Widget::create_widget_package('Menu');
    Tcl::Tk::Widget::create_widget_package('Menubutton');
    Tcl::Tk::Widget::create_method_in_widget_package('Menubutton',
	command=>sub {
	    my $wid = shift;
	    my $int = $wid->interp;
	    my %args = @_;

            # Convert -bg and -fg abbreviations to -background and -foreground
            #   These abbreviations are valid in perl/tk, but not in Tcl/tk, so we have to
            #  translate
            $args{-foreground} = delete($args{-fg}) if( defined($args{-fg}));
            $args{-background} = delete($args{-bg}) if( defined($args{-bg}));

	    $wid->_process_underline(\%args);
            $wid->menu->Command(%args);
	},
	checkbutton => sub {
            shift->menu->Checkbutton(@_);
	},
	radiobutton => sub {
            shift->menu->Radiobutton(@_);
	},
	cascade => sub {
	    my $wid = shift;
            my $menu = $wid->menu(); # get the menu
	    $menu->_addcascade(@_);
	},
	separator => sub {
            shift->menu->Separator(@_);
	},
	menu => sub {
	    my $wid = shift;
	    return $wid->cget(-menu);
	},
	cget => sub {
	    my $wid = shift;
	    my $int = $wid->interp;
	    if ($_[0] eq "-menu") {
		return $int->widget($int->invoke("$wid",'cget','-menu'));
	    } else {
                $wid->SUPER::cget(@_);
	    }
	},
        # Entryconfigure just calls entryconfigure on the menu component
        entryconfigure => sub{
                my $wid = shift;
                return $wid->menu->entryconfigure(@_);
        },
        # entrycget just calls entrycget on the menu component
        entrycget => sub{
                my $wid = shift;
                return $wid->menu->entrycget(@_);
        },
        );
    my ($mnub, $mnu);
    
    # For creating menubuttons on a already-created menu, create a cascade item
    if( $self->isa('Tcl::Tk::Widget::Menu') ){
            $mnu = $self;
            
            # Get name, if defined
            my $name = delete($args{-text}) || delete($args{-label});
            $args{-label} = $name if( defined( $name ));
            
            my $hash = $self->TkHash('MenuButtons'); # See if we already created this menubutton
            $mnub = $hash->{$name};
            
            if( defined($mnub) ){ # Configure existing menubutton
                    $mnub->configure(%args) if (%args);
            }
            else{ # Create new menubutton on the menu
                    $args{-tearoff} = 0 unless( defined($args{-tearoff}) ); # Cascade items shouldn't be tearoff, by default
                    $mnub = $mnu->cascade(%args, -menuitems => $mis);
                    $hash->{$name} = $mnub;
            }
            return $mnub;
    }

    # Not calling menubutton on a menu (Normal Case)
    $mnub = $int->widget(
        $self->call('menubutton', $w, -menu => "$w.m", %args),
                "Tcl::Tk::Widget::Menubutton");
    
    $mnu = $int->widget($self->call('menu',"$w.m"), "Tcl::Tk::Widget::Menu");
    #print "menubutton = '$mnub'\n";
    #print "menu = '$mnu'\n";
    $mnub->_process_menuitems($int,$mnu,$mis);
    if (defined($tearoff)) {
        $mnu->configure(-tearoff => $tearoff);
    }
    

    return $mnub;
}

1;


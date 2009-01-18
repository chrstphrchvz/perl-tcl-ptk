#!/usr/local/bin/perl -w

#use Tk;
#use Tk::HList;
#use Tk::ItemStyle;
use Tcl::Tk qw(:perlTk);
use Tcl::Tk::Widget::ItemStyle;
use Test;
plan tests => 1;

$top = MainWindow->new;
$redstyle  = $top->ItemStyle('text',
			     -foreground => 'red',
			     -font => '10x20',
			     -background => 'green');

#print $redstyle,"\n";

$bluestyle = $top->ItemStyle('text',
			     -foreground => 'blue',
			     -background => 'white',
			    );
$hl = $top->HList->pack(-expand=> 'y', -fill => 'both');

$hl->add(0, -itemtype => 'text', -text => 'Changed from Green to Cyan', -style => $redstyle);
$hl->add(1, -itemtype => 'text', -text => 'blue', -style => $bluestyle);


#$redstyle->configure(-background => 'cyan');
$top->after(2000, [ configure => $redstyle, -background => 'cyan' ]);
$top->after(3000, sub{
                $hl->entryconfigure(0, -text => 'Changed to Cyan');
}
);

$top->after(4000, sub{
                $top->destroy;
}
);

MainLoop;

ok(1);


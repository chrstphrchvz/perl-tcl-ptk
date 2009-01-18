# button.pl

#use Tk;
#use Tk::Balloon;

use Tcl::Tk qw/:perlTk/;

use Test;

plan test => 1;

my $TOP = MainWindow->new;

my $bln = $TOP->Balloon();

	my $b = $TOP->Button( Name => 'btn',
            -text    => "Balloon Test",
            -width   => 10,
        )->pack;
 
$bln->attach($b, -msg => "Popup help");

$TOP->after(1000, sub{
                $b->eventGenerate('<Motion>', -x => 10, -y => 10);
}
);
$TOP->after(3000, [ $TOP, 'destroy']);

MainLoop;

ok(1);

# button.pl

use warnings;
use strict;

#use Tk;
#use Tk::Balloon;

use Tcl::pTk;

use Test;

plan test => 4;

my $TOP = MainWindow->new;

my $bln = $TOP->Balloon();

	my $b = $TOP->Button( Name => 'btn',
            -text    => "Balloon Test",
            -width   => 10,
        )->pack;
        
# Check to make sure the classname is properly assigned
my $class = $bln->class;
ok($class, 'Balloon', "Balloon Classname Check");
 
 
$bln->attach($b, -msg => "Popup help");
$TOP->update;
ok($bln->state, 'withdrawn', 'Balloon withdrawn');

$b->eventGenerate('<Motion>', -x => 10, -y => 10);
$TOP->update;

ok($bln->state , 'withdrawn', 'Balloon not yet visible');

$TOP->after(500, sub {
    ok($bln->state, 'normal', 'Balloon now visible');
    $TOP->destroy unless (@ARGV);
});

MainLoop;

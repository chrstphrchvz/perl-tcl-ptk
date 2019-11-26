# entry1.pl

use warnings;
use strict;
use Test;
use Tcl::pTk;
#use Tk;

my $textVar = "Initial Value";

$| = 1;


my $TOP = MainWindow->new();

# This will skip if Tile widgets not available
unless ($Tcl::pTk::_Tile_available) {
    print "1..0 # Skipped: Tile unavailable\n";
    exit;
}

plan tests => 3;

# Parameters passed to the -validatecommand
my ($proposed, $changes, $current, $index, $type) ;
my $invalid = 0;
my(@pl) = qw/-side top -padx 10 -pady 5 -fill x -expand 1/;
my $e1 = $TOP->ttkEntry(
            -validate        => 'focus',
            -validatecommand => sub {
                    ($proposed, $changes, $current, $index, $type) = @_;
                    #print join(", ", $proposed, $changes, $current, $index, $type)."\n";
                    return not $proposed =~ m/[^\d]/g;
            },
            -invalidcommand => sub{ $invalid = 1; return 0}  # invalid will be set to 1 if called
)->pack(@pl);

$TOP->focusForce; # workaround for Tk Aqua 8.5.9

# Generate some events for testing
$TOP->after(1000, sub{
                $e1->eventGenerate('<1>'); # 
                $e1->eventGenerate('<Key-a>'); # 
}        );

$TOP->after(2000, sub{
                $TOP->destroy;
}        );

MainLoop;

ok($index, -1, "Validate Command index problem");
ok($type, -1, "Validate Command type problem");
ok($invalid, 1, "Validate -invalidcommand problem");




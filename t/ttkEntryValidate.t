# entry1.pl

use strict;
use Test;
use Tcl::pTk qw/:perlTk/;
#use Tk;

plan tests => 3;

my $textVar = "Initial Value";

$| = 1;


my $TOP = MainWindow->new();

my $version = $TOP->tclVersion;
# print "version = $version\n";

# Skip if Tcl/Tk version is < 8.5
if( $version < 8.5 ){
        skip("Tile widgets only works for Tcl >= 8.5", 1);
        skip("Tile widgets only works for Tcl >= 8.5", 1);
        skip("Tile widgets only works for Tcl >= 8.5", 1);
        exit;
}

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




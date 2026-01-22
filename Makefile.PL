use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use ExtUtils::MakeMaker;

my $i;
my $tk_patchLevel;

sub _die ($) {
    # CPAN smokers report FAIL if Makefile.PL dies, it should exit with status 0
    my $err = shift;
    warn $err;
    # Cleanly exit Tcl/Tk if it was loaded
    $i->Eval('destroy .') if ($tk_patchLevel);
    exit 0;
}

## The executable scripts to be installed
my @SCRIPTS   = qw( widgetTclpTk
               );

# Allow bypassing with --no-test-for-tk
my $test_for_tk = 1;


GetOptions(
    "help!",   \ my $help,
    "test-for-tk!", \$test_for_tk,
) || usage();
usage() if $help;
sub usage {
    _die <<'EOT';
Usage: perl Makefile.PL [--no-test-for-tk] [<makemaker opts>...]
EOT
}


# Unless --no-test-for-tk was specified, check the Tcl/Tk installation
# using Tcl.pm (which is how Tcl::pTk will use Tcl/Tk; better than
# looking/asking for a tclsh command not necessarily from the same
# Tcl/Tk installation used by Tcl.pm)
if ($test_for_tk) {

    # Load Tcl via Tcl.pm
    eval {
        require Tcl;
        1;
    } or do {
        my $error = $@ || 'Unknown error';
        _die <<"EOS"
Error: couldn't load Tcl.pm for Tcl/Tk check (use --no-test-for-tk to skip), reason: $error
EOS
    };
    $i = new Tcl;
    $i->Init;
    print STDERR "Tcl.pm $Tcl::VERSION\n";
    printf STDERR "Tcl %s\n", $i->GetVar('tcl_patchLevel');

    # Check for Tcl/Tk
    eval {
        $tk_patchLevel = $i->Eval('package require Tk');
        1;
    } or do {
        my $error = $@ || 'Unknown error';
        _die <<"EOS";
Error: couldn't load Tcl/Tk (use --no-test-for-tk to skip), reason: $error
EOS
    };
    unless ($i->Eval('package vsatisfies $tk_version 8.5')) {
        warn <<"EOS";
Warning: Tcl/Tk $tk_patchLevel detected; Tcl/Tk 8.5 or later is recommended for full functionality
EOS
    } else {
        printf STDERR "Tcl/Tk %s\n", $i->GetVar('tk_patchLevel');
    }

    # Check for recommended Tcl/Tk packages

    my $tile_version = '';
    eval {
        $tile_version = $i->Eval('package require tile');
        1;
    } or warn <<'EOS';
Warning: Tile package not detected; Tcl/Tk 8.5.9 or Tile 0.8.4.0 for Tcl/Tk 8.4 is recommended
EOS
    if ($i->Eval("package vcompare $tile_version 0.8.4.0") == -1) {
        warn <<"EOS";
Warning: Tile $tile_version detected; Tcl/Tk 8.5.9 or Tile 0.8.4.0 for Tcl/Tk 8.4 is recommended
EOS
    } else {
        print STDERR "Tile $tile_version\n";
    }

    my $tix_version = '';
    eval {
        $tix_version = $i->Eval('package require Tix');
        print STDERR "Tix $tix_version\n";
        1;
    } or warn <<'EOS';
Warning: Tix package not detected; Tix is needed for full compatibility with Perl/Tk (information at http://tix.sourceforge.net)
EOS

    my $tooltip_version = '';
    eval {
        $tooltip_version = $i->Eval('package require tooltip');
        print STDERR "tklib detected\n"
                   . "tooltip $tooltip_version\n";
        1;
    } or warn <<'EOS';
Warning: tklib not detected; tklib is recommended for full functionality
EOS

    # Check for optional Tcl/Tk packages

    my $img_version = 'N/A';
    eval {
        $img_version = $i->Eval('package require Img');
        1;
    };
    print STDERR "Img $img_version\n";

    my $bwidget_version = 'N/A';
    eval {
        $bwidget_version = $i->Eval('package require BWidget');
        1;
    };
    print STDERR "BWidget $bwidget_version\n";

    my $treectrl_version = 'N/A';
    eval {
        $treectrl_version = $i->Eval('package require treectrl');
        1;
    };
    print STDERR "TkTreeCtrl $treectrl_version\n";

    # Loading Tktable can cause crash when exiting; skip check for now
    # https://rt.cpan.org/Ticket/Display.html?id=132278
    if (0) {
    my $tktable_version = 'N/A';
    eval {
        $tktable_version = $i->Eval('package require Tktable');
        1;
    };
    print STDERR "Tktable $tktable_version\n";
    }

    # Cleanly exit Tcl/Tk if it was loaded
    $i->Eval('destroy .') if ($tk_patchLevel);
}

my %makeArgs = (
    NAME => "Tcl::pTk",
    ABSTRACT_FROM => 'lib/Tcl/pTk.pm',
    VERSION_FROM => 'lib/Tcl/pTk.pm',
    LICENSE => 'perl_5',
    MIN_PERL_VERSION => '5.008',
    EXE_FILES => \@SCRIPTS,
    META_MERGE => {
        "meta-spec" => { version => 2 },
        no_index => {
            directory => [ qw! benchmarks TableMatrixDemos lib/Tcl/pTk/demos ! ],
            'package' => [ 'MainWindow' ],
        },
        keywords => [ qw/ Tk Tcl Tix GUI /],
        resources => {
            repository => {
                type => 'git',
                url => 'https://github.com/chrstphrchvz/perl-tcl-ptk.git',
                web => 'https://github.com/chrstphrchvz/perl-tcl-ptk',
            },
            bugtracker => {
                web => 'https://github.com/chrstphrchvz/perl-tcl-ptk/issues',
            },
            MailingList => 'mailto:tcltk@perl.org',
        },
    },
    PREREQ_PM => {
        'Tcl' => '0.90',
        'Class::ISA' => '0.36',
        'Sub::Name' => '0.05',
        'Time::HiRes' => 0,
    },
    TEST_REQUIRES => {
        'Test::Deep' => 0,
        'Test::More' => 0,
    },
);

# Remove META_MERGE parameter for older versions of ExtUtils::MakeMaker
my $MMversion = $ExtUtils::MakeMaker::VERSION;
#print "VERSION = $MMversion\n";
$MMversion =~ s/_\d+$//; # Get rid of underscores in the version for numeric compare
delete $makeArgs{META_MERGE} if( $MMversion < 6.45 );
delete $makeArgs{MIN_PERL_VERSION} if ( $MMversion < 6.48 );
delete $makeArgs{TEST_REQUIRES} if ( $MMversion < 6.64 );

WriteMakefile(
%makeArgs
);

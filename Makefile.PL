use strict;
use warnings;

use lib 'inc';
use ExtUtils::MakeMaker::Dist::Zilla::Develop;

# keep this code consistent with the [MakeMaker::Awesome] arguments in dist.ini
use ExtUtils::Depends 0.302;

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::PPAddr');
$pkg->install('hook_op_ppaddr.h');
$pkg->add_xs('PPAddr.xs');
$pkg->add_pm('lib/B/Hooks/OP/PPAddr.pm' => '$(INST_LIB)/B/Hooks/OP/PPAddr.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

WriteMakefile(
    NAME => 'B::Hooks::OP::PPAddr',
    VERSION_FROM => 'lib/B/Hooks/OP/PPAddr.pm',
    INSTALLMAN1DIR => 'none',
    INSTALLMAN3DIR => 'none',
    NORECURS => 1,
    $pkg->get_makefile_vars,
    FUNCLIST => [qw/hook_op_ppaddr hook_op_ppaddr_around/],
    DL_FUNCS => { 'B::Hooks::OP::PPAddr' => [] },
    dist => { PREOP => 'pod2text lib/B/Hooks/OP/PPAddr.pm > $(DISTVNAME)/README' },
);

use Devel::PPPort;
Devel::PPPort::WriteFile();
system("$^X ppport.h --compat-version=5.006 --quiet *.{h,c,xs}");

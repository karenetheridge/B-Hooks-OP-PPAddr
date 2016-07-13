use strict;
use warnings;
package B::Hooks::OP::PPAddr;
# ABSTRACT: Hook into opcode execution

use parent qw/DynaLoader/;

our $VERSION = '0.06';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;

__END__

=head1 SYNOPSIS

    #include "hook_op_check.h"
    #include "hook_op_ppaddr.h"

    STATIC OP *
    execute_entereval (pTHX_ OP *op, void *user_data) {
        ...
    }

    STATIC OP *
    check_entereval (pTHX_ OP *op, void *user_data) {
        hook_op_ppaddr (op, execute_entereval, NULL);
    }

    hook_op_check (OP_ENTEREVAL, check_entereval, NULL);

=head1 DESCRIPTION

This module provides a C API for XS modules to hook into the execution of perl
opcodes.

L<ExtUtils::Depends> is used to export all functions for other XS modules to
use. Include the following in your F<Makefile.PL>:

    my $pkg = ExtUtils::Depends->new('Your::XSModule', 'B::Hooks::OP::PPAddr');
    WriteMakefile(
        ... # your normal makefile flags
        $pkg->get_makefile_vars,
    );

Your XS module can now include C<hook_op_ppaddr.h>.

=head1 TYPES

=head2 OP

    typedef OP *(*hook_op_ppaddr_cb_t) (pTHX_ OP *, void *user_data)

Type that callbacks need to implement.

=head1 FUNCTIONS

=head2 hook_op_ppaddr

    void hook_op_ppaddr (OP *op, hook_op_ppaddr_cb_t cb, void *user_data)

Replace the function to execute C<op> with the callback C<cb>. C<user_data>
will be passed to the callback as the last argument.

=head2 hook_op_ppaddr_around

    void hook_op_ppaddr_around (OP *op, hook_op_ppaddr_cb_t before, hook_op_ppaddr_cb_t after, void *user_data)

Register the callbacks C<before> and C<after> to be called before and after the
execution of C<op>. C<user_data> will be passed to the callback as the last
argument.

=head1 SEE ALSO

=for :list
* L<B::Hooks::OP::Check>

=cut

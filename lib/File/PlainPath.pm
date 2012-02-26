use strict;
use warnings;
package File::PlainPath;

# ABSTRACT: Construct portable filesystem paths in a simple way

use File::Spec;

=head1 SYNOPSIS

    use File::PlainPath qw(path);
    
    # Forward slash is the default directory separator
    my $path = path 'dir/subdir/file.txt';
    
    # Set backslash as directory separator
    File::PlainPath::set_separator('\\');   
    my $other_path = path 'dir\\other_dir\\other_file.txt';

=head1 DESCRIPTION

File::PlainPath translates filesystem paths that use a common directory
separator to OS-specific paths. It allows you to replace constructs like this:

    my $path = File::Spec->catfile('dir', 'subdir', 'file.txt');
    
with a simpler notation:

    my $path = path 'dir/subdir/file.txt';
    
The default directory separator used in paths is the forward slash (C</>), but
any other character can be designated as the separator:

    File::PlainPath::set_separator(':');
    my $path = path 'dir:subdir:file.txt';

=cut

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(path to_path);

# Directory separator
my $separator;
# Regular expression that matches directory separators
my $separator_re;

=func path

Translates the provided path to OS-specific format.

Example:

    my $path = path 'dir/file.txt';
    
=cut

sub path {
    my $path = shift;
    
    return File::Spec->catfile(split($separator_re, $path));
}

=func to_path

An alias for L<path>. Use it when there's another module that exports a
subroutine named C<path> (such as L<File::Spec::Functions>).

Example:

    use File::PlainPath qw(to_path);
    
    my $path = to_path 'dir/file.txt';

=cut

*to_path = *path;

=func set_separator

Sets the character to be used as directory separator.

Example:

    File::PlainPath::set_separator(':');

=cut

sub set_separator {
    $separator = quotemeta(shift);
    $separator_re = qr{$separator};
}

# Set forward slash as the default directory separator
set_separator('/');

=head1 SEE ALSO

=over 4

=item * L<File::Spec>

=back

=cut

1;

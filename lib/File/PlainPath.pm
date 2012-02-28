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

    use File::PlainPath -split => ':';
    my $path = path 'dir:subdir:file.txt';

This is lexically scoped.

=cut

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(path to_path);

sub import
{
    my $class  = shift;
    my %opts   = ();
    my @export = ();
    while (@_) {
        my $arg = shift;
        if ($arg =~ m{^ [-] (.+) $}x)
        {
            $opts{$1} = shift;
            next;
        }
        push @export, $arg;
    }
    
    if (exists $opts{'split'}) {
        $^H{+__PACKAGE__} = $opts{'split'};
    }
    
    @_ = ($class, @export);
    goto \&Exporter::import;
}

=func path

Translates the provided path to OS-specific format. If more than one path is
specified, the paths are concatenated to produce the resulting path. 

Examples:

    my $path = path 'dir/file.txt';

    my $path = path 'dir', 'subdir/file.txt';
    # On Unix, this produces: "dir/subdir/file.txt" 
    
=cut

sub path {    
    my @caller       = caller(0);
    my $separator    = exists $caller[10]{+__PACKAGE__} ? $caller[10]{+__PACKAGE__} : '/';
    my $separator_re = qr{ \Q$separator\E }x;
    
    my @paths = @_;
    my @path_components = map { split($separator_re, $_) }
        @paths;
    return File::Spec->catfile(@path_components);
}

=func to_path

An alias for L</path>. Use it when there's another module that exports a
subroutine named C<path> (such as L<File::Spec::Functions>).

Example:

    use File::PlainPath qw(to_path);
    
    my $path = to_path 'dir/file.txt';

=cut

*to_path = *path;

=head1 SEE ALSO

=over 4

=item * L<File::Spec>

=back

=cut

1;

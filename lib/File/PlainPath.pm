use strict;
use warnings;
package File::PlainPath;

# ABSTRACT: Construct portable filesystem paths in a simple way

use File::Spec;

=head1 SYNOPSIS

    use File::PlainPath;
    
    # Forward slash is the default directory separator
    my $path = path 'dir/subdir/file.txt';
    
    # Set backslash as directory separator
    use File::PlainPath '\\';   
    my $other_path = path 'dir\\other_dir\\other_file.txt';

    # Forward slash is the default directory separator, but function name is to_path
    use File::PlainPath to_path => '/';   
    my $path = to_path 'dir/subdir/file.txt';

=head1 DESCRIPTION

File::PlainPath translates filesystem paths that use a common directory
separator to OS-specific paths. It allows you to replace constructs like this:

    my $path = File::Spec->catfile('dir', 'subdir', 'file.txt');
    
with a simpler notation:

    my $path = path 'dir/subdir/file.txt';
    
The default directory separator used in paths is the forward slash (C</>), but
any other character can be designated as the separator:

    use File::PlainPath ':';
    my $path = path 'dir:subdir:file.txt';

=head1 IMPORT

When importing File::PlainPath, if no arguments are given, the imported function is C<path> and it uses the separator C</>. Called with one argument, the function is still called C<path> but the separator is now that argument. Called with two arguments the first is the function name and the second is the separator. For examples see L</SYNOPSIS>.

=cut

sub import {
  my $class     = shift;
  my $caller    = caller;
  my $separator = pop || '/';
  my $name      = pop || 'path';

  my $separator_re = qr/\Q$separator\E/;

  my $sub = sub {
    my @paths = @_;
    
    my @path_components = map { split($separator_re, $_) } @paths;
    return File::Spec->catfile(@path_components);
  };

  no strict 'refs';
  *{$caller . "::" . $name} = $sub;
}

=head1 SEE ALSO

=over 4

=item * L<File::Spec>

=back

=cut

1;

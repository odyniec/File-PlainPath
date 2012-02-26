#!perl -T

use Test::More;
use File::Spec;

BEGIN {
    use_ok('File::PlainPath', qw(path to_path));
}

is(path('foo'), File::Spec->catfile('foo'),
    'Make path from a single dirctory/file name');

is(path('foo/bar'), File::Spec->catfile('foo', 'bar'),
    'Make path with the default separator');
is(path('foo/bar\\baz'), File::Spec->catfile('foo', 'bar\\baz'),
    'Make path with backslash in file name');

# Set backslash as directory separator
File::PlainPath::set_separator('\\');

is(path('foo\\bar'), File::Spec->catfile('foo', 'bar'),
    'Make path with separator set to "\\"');

# Set pipe as directory separator
File::PlainPath::set_separator('|');

is(path('foo|bar'), File::Spec->catfile('foo', 'bar'),
    'Make path with separator set to "|"');
is(path('foo|bar\\baz'), File::Spec->catfile('foo', 'bar\\baz'),
    'Make path with backslash in file name');

is(\&path, \&to_path, 'path and to_path are the same subroutine');

done_testing;

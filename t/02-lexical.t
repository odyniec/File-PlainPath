#!perl -T

use Test::More tests => 3;
use File::PlainPath -split => '*', qw(path);

my $first = path 'a*b&b*c';

my $second = do {
    use File::PlainPath -split => '&';
    path 'a*b&b*c';
};

my $third = path 'a*b&b*c';

is($first,  File::Spec->catfile('a', 'b&b', 'c'));
is($second, File::Spec->catfile('a*b', 'b*c'));
is($third,  File::Spec->catfile('a', 'b&b', 'c'));

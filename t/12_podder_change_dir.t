use strict;
use Test::More;
use Podder;

my $podder = Podder->new( doc_root => './lib' );
ok( $podder->dir_diff );
done_testing;

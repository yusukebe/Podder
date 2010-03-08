use strict;
use Test::More;
use Podder;

my $podder = Podder->new( doc_root => './lib' );
diag $podder->doc_root;
done_testing;

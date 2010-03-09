use strict;
use Test::More;
use Podder;

my $podder = Podder->new( doc_root => './' );
ok( $podder );
done_testing;

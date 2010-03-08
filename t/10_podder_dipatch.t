use strict;
use Test::More;
use Podder;

my $podder = Podder->new( doc_root => './' );
ok( $podder );
my $code = $podder->dispatch('/');
ok( $code );
done_testing;

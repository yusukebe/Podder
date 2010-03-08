use strict;
use Test::More;
use Podder;

eval{
    Podder->new( doc_root => '/home/' );
};
ok( $@ );
done_testing;

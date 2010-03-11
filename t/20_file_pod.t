use strict;
use Test::More;
use Path::Class qw( file );

use_ok ('Podder::File::Pod');
my $file = file('./t/Test.pm');
my $html = Podder::File::Pod->html( $file );
ok($html);
done_testing;


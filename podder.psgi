use lib qw(./lib);
use Podder;

my $podder = Podder->new( doc_root => './' );
$podder->handler;

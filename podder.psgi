use lib qw(./lib);
use Podder;
use Plack::Builder;

my $podder = Podder->new( doc_root => './' );
builder {
    enable "Plack::Middleware::Static",
      path => qr{^/static},
      root => './root/';
    $podder->handler();
};



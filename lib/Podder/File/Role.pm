package Podder::File::Role;
use Mouse::Role;
use Encode;

sub determine {
    my ( $self, $file ) = @_;
    my $square = "\x{25a0}";
    for ( $file->slurp ) {
        return 'inao' if Encode::decode( 'utf8', $_ ) =~ /$square/;
        return 'hatena' if $_ =~ /^\*/;
    }
    return '';
}

1;

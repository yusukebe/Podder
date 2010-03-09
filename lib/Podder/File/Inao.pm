package Podder::File::Inao;
use Mouse;
with 'Podder::File::Role';

sub html {
    my ( $self, $file ) = @_;
    return unless $self->determine( $file ) eq 'inao';
    my $html;
    eval {
        require Acme::Text::Inao;
	my $text = $file->slurp;
        $html = Acme::Text::Inao->new->from_inao( Encode::decode( 'utf8',$text ) )->to_html();
        $html = Encode::encode('utf8', $html);
    };
    return $html if !$@;
    return;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

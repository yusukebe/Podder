package Podder::File::Hatena;
use Mouse;
with 'Podder::File::Role';

sub html {
    my ( $self, $file ) = @_;
    return unless $self->determine( $file ) eq 'hatena';
    my $html;
    eval {
	require Text::Hatena;
	my $text = join '' , $file->slurp;
	$html = Text::Hatena->parse($text);
    };
    $::RD_AUTOACTION = ''; #XXX
    return $html unless $@;
    return;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

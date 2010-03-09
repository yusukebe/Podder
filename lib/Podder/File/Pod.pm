package Podder::File::Pod;
use Mouse;
with 'Podder::File::Role';

sub html {
    my ( $self, $file ) = @_;
    $file = file ($file) unless ref $file eq 'Path::Class::File';
    require Pod::Simple::XHTML;
    my $parser = Pod::Simple::XHTML->new();
    my $html;
    $parser->output_string( \$html );
    $parser->html_header('');
    $parser->html_footer('');
    $parser->html_h_level(3);
    my @documents = map { Encode::decode('utf8',$_) } $file->slurp;
    $parser->parse_string_document( @documents );
    return $html;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;


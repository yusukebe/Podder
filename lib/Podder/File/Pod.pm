package Podder::File::Pod;
use Mouse;
with qw/Podder::Role Podder::File::Role/;
use HTML::TreeBuilder::XPath;
use HTML::Entities;

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
    $html = $self->highlight_pod( $html );
    return $html;
}

sub highlight_pod {
    my ( $self, $html ) = @_;
    my $tree = HTML::TreeBuilder::XPath->new;
    $tree->parse( $html );
    for my $code ( $tree->findnodes('//pre') ){
        my $hilight_code = $self->highlight( $code->as_text );
        my $code_html = $code->as_HTML;
        $html =~ s/\Q$code_html\E/<pre>$hilight_code<\/pre>/m;
    }
    return $html;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;


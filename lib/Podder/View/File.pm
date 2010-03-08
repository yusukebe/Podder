package Podder::View::File;
use Mouse;
use MouseX::Types::Path::Class;
use Pod::Simple::XHTML;
use Text::VimColor;
with 'Podder::View';
use Carp;

has 'file' =>
  ( is => 'ro', isa => 'Path::Class::File', required => 1, coerce => 1 );

sub BUILDARGS {
    my ( $self, $file ) = @_;
    return { file => $file };
}

sub render {
    my ( $self, $params ) = @_;
    my $content = $self->file->slurp();
    $content = $self->highlight($content);
    my $parents = $self->parents();
    my $pod     = $self->pod();
    $self->render_tt(
        'file.tt2',
        {
            content => $content,
            title   => $self->file->relative,
            pod     => $pod,
            parents => $parents,
            modified_date => $self->modified_date( $self->file->stat ),
            %$params
        }
    );
}

sub parents {
    my $self = shift;
    my $path = $self->file->relative;
    my @dirs = split '/',$path;
    return \@dirs;
}

sub highlight {
    my ( $self, $text ) = @_;
    my $syntax = Text::VimColor->new(
        string     => $text,
        filetype => 'perl', #xxx
    );
    return $syntax->html;
}

sub pod {
    my ( $self, $text ) = @_;
    my $parser = Pod::Simple::XHTML->new();
    my $body;
    $parser->output_string( \$body );
    $parser->html_header('');
    $parser->html_footer('');
    $parser->html_h_level(3);
    $parser->parse_file( $self->file->stringify );
    return $body;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

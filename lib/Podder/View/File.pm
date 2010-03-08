package Podder::View::File;
use Mouse;
use MouseX::Types::Path::Class;
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
    my $self = shift;
    my $content = $self->file->slurp();
    $content = $self->highlight( $content );
    $self->render_tt( 'file.tt2', { content => $content, title => $self->file->relative } );
}

sub highlight {
    my ( $self, $text ) = @_;
    my $syntax = Text::VimColor->new(
        string     => $text,
        filetype => 'perl', #xxx
    );
    return $syntax->html;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

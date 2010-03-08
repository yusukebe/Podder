package Podder::View::Dir;
use Mouse;
use MouseX::Types::Path::Class;
with 'Podder::View';
use Carp;

has 'dir' =>
  ( is => 'ro', isa => 'Path::Class::Dir', required => 1, coerce => 1 );

sub BUILDARGS {
    my ( $self, $dir ) = @_;
    return { dir => $dir };
}

sub render {
    my $self     = shift;
    my @children = $self->dir->children;
    $self->render_tt( 'dir.tt2',
        { children => \@children, title => $self->dir->relative } );
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

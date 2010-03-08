package Podder::View::Dir;
use Mouse;
use MouseX::Types::Path::Class;
use Path::Class qw( dir );
with 'Podder::View';
use Carp;

has 'dir' =>
  ( is => 'ro', isa => 'Path::Class::Dir', required => 1, coerce => 1 );

sub BUILDARGS {
    my ( $self, $dir ) = @_;
    return { dir => $dir };
}

sub render {
    my ( $self, $params ) = @_;
    my @children = $self->dir->children;
    my $parents  = $self->parents;
    $self->render_tt(
        'dir.tt2',
        {
            children => \@children,
            title    => $self->dir->relative eq '.' ? '' : $self->dir->relative,
            parents  => $parents,
            modified_date => $self->modified_date( $self->dir->stat ),
            %$params,
        }
    );
}

sub parents {
    my $self = shift;
    my $path = $self->dir->relative;
    my @dirs = split '/',$path;
    return \@dirs;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

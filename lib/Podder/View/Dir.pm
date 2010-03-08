package Podder::View::Dir;
use Mouse;
use MouseX::Types::Path::Class;
use Path::Class qw( dir );
with 'Podder::View';
use Carp;

has 'dir' =>
  ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );
has 'dir_diff' => ( is => 'rw', isa => 'Str', required => 1 );

sub BUILDARGS {
    my ( $self, $dir, $dir_diff ) = @_;
    return { dir => $dir, dir_diff => $dir_diff };
}

sub render {
    my ( $self, $params ) = @_;
    my $children = $self->children;
    my $parents  = $self->parents;
    $self->render_tt(
        'dir.tt2',
        {
            children => $children,
            title    => $self->dir->relative eq '.' ? '' : $self->dir->relative,
            parents  => $parents,
            modified_date => $self->modified_date( $self->dir->stat ),
            %$params,
        }
    );
}

sub children {
    my $self = shift;
    my @children;
    my $diff = $self->dir_diff;
    for my $c ( $self->dir->children ) {
        my $name = $c->relative->stringify;
        if( $diff ne '.' ) {
            $name =~ s/$diff//;
            $name =~ s/^\///;
        }
        push @children , { name => $name, class => $c };
    }
    return \@children;
}

sub parents {
    my $self = shift;
    my $path = $self->dir->relative;
    my @dirs = split '/', $path;
    return \@dirs;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

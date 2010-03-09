package Podder::File;
use Mouse;
use MouseX::Types::Path::Class;
with 'Podder::Role';
use Carp;

has 'file' =>
  ( is => 'ro', isa => 'Path::Class::File', required => 1, coerce => 1 );

sub BUILDARGS {
    my ( $self, $file ) = @_;
    return { file => $file };
}

sub stash {
    my $self    = shift;
    my $content = $self->file->slurp();
    if( -B $self->file->stringify ){
	return { content => $content, is_binary => 1 };
    }
    $content = $self->highlight($content);
    my $parents = $self->parents();
    my $pod = $self->pod;
    return {
        template      => 'file.tt2',
        content       => $content,
        title         => $self->file->relative,
        pod           => $pod,
        parents       => $parents,
        modified_date => $self->modified_date( $self->file->stat ),
    };
}

#XXX no sense
sub pod {
    my $self = shift;
    my $pod = '';
    $pod = $self->pod2html( $self->file );
    return $pod if $pod;
    $pod = $self->inao2html( $self->file );
    return $pod if $pod;
    $pod = $self->hatena2html( $self->file );
    return $pod if $pod;
    return;
}

sub parents {
    my $self = shift;
    my $path = $self->file->relative;
    my @dirs = split '/',$path;
    return \@dirs;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

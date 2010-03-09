package Podder::File;
use Mouse;
use MouseX::Types::Path::Class;
with 'Podder::Role';
use Carp;
use Podder::File::Pod;
use Podder::File::Inao;
use Podder::File::Hatena;

has 'file' =>
  ( is => 'ro', isa => 'Path::Class::File', required => 1, coerce => 1 );
has 'extention' => ( is => 'rw', isa => 'Str', lazy_build => 1 );

sub _build_extention {
    my $self = shift;
    my $ext = '';
    ($ext) = $self->file->stringify =~ /\.([^\.]+)$/;
    return $ext;
}

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
    my $pod;
    if( grep { $self->extention eq $_ } qw/pl pod pm/ ){
      $pod = Podder::File::Pod->html( $self->file );
      return $pod if $pod;
    }
    if( grep { $self->extention eq $_ } qw/txt/ ){
      $pod = Podder::File::Inao->html( $self->file );
      return $pod if $pod;
      $pod = Podder::File::Hatena->html( $self->file );
      return $pod if $pod;
    }
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

package Podder::Dir;
use Mouse;
with 'Podder::Role';
use MouseX::Types::Path::Class;
use Path::Class qw( dir );
use Carp;

has 'dir' =>
  ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );
has 'dir_diff' => ( is => 'rw', isa => 'Str', required => 1 );

sub BUILDARGS {
    my ( $self, $dir, $dir_diff ) = @_;
    return { dir => $dir, dir_diff => $dir_diff };
}

sub stash {
    my $self     = shift;
    my $children = $self->children;
    my $parents  = $self->parents;
    return {
        template => 'dir.tt2',
        children => $children,
        title    => $self->dir->relative eq '.' ? '' : $self->dir->relative,
        parents  => $parents,
        modified_date => $self->modified_date( $self->dir->stat ),
    };
}

sub children {
    my $self = shift;
    my @children;
    my $diff = $self->dir_diff;
    my $lines = $self->ignores;
    for my $c ( $self->dir->children ) {
        my $name = $c->relative->stringify;
        if( $diff ne '.' ) {
            $name =~ s/$diff//;
            $name =~ s/^\///;
        }
        if ( $self->is_ignore( $name, $lines ) ){
        }else{
            push @children , { name => $name, class => $c };
        }
    }
    return \@children;
}

sub parents {
    my $self = shift;
    my $path = $self->dir->relative;
    my @dirs = split '/', $path;
    return \@dirs;
}

sub is_ignore {
    my ( $self, $target, $list ) = @_;
    for my $str ( @$list ){
        return 1 if $target =~ /$str/;
    }
    return;
}

sub ignores {
    my @lines;
    while(<DATA>){
        next unless $_;
        chomp($_);
        push @lines, $_;
    }
    return \@lines;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

__DATA__
\bRCS\b
\bCVS\b
~$
^#
\.old$
^blib
^pm_to_blib
\.gz$
\.svn
^\.git

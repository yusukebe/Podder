package Podder;
use Mouse;
use MouseX::Types::Path::Class;
use Path::Class qw( dir );
use Plack::Request;
use Carp;

our $VERSION = '0.01';

has 'doc_root' =>
  ( is => 'ro', isa => 'Path::Class::Dir', required => 1, coerce => 1 );
has 'base_root' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 1,
    default  => sub {
        my $dir = dir( $INC{'Podder.pm'} );
        return $dir->parent->subdir('Podder')->subdir('root');
    }
);
has 'dir_diff' => (
      is       => 'ro',
      isa      => 'Str',
      required => 1,
      default  => sub {
          my $self = shift;
          my $rel = $self->doc_root->relative->stringify;
          return  $rel;
      }
  );

sub BUILD {
    my ($self, $args) = @_;
    if(length $self->doc_root->absolute < length dir('./')->absolute){
        die "Podder don't work with unsafe doc_root\n";
    }
}

sub handler {
    my $self = shift;
    return sub {
        my $env = shift;
        my $req = Plack::Request->new( $env );
        my $path_info = $req->path_info();
        my $code = $self->dispatch( $path_info );
        return $code;
    }
}

sub dispatch {
    my ( $self, $path_info ) = @_;

    if( $path_info =~ m!^/podder_static! ){
        return $self->serve_static( $path_info );
    }

    my $view;
    eval {
        if ( $self->doc_root->file($path_info)->slurp() )
        {
            require Podder::View::File;
            $view = Podder::View::File->new( $self->doc_root->file($path_info),
                $self->dir_diff );
        }
        else {
            require Podder::View::Dir;
            $view = Podder::View::Dir->new( $self->doc_root->subdir($path_info),
                $self->dir_diff );
        }
    };
    if( $@ ){
        warn $@;
        my $body = $@;
        return [404, ["Content-Type" => "text/plain", "Content-Length" => length $body], [$body] ];
    }
    my $root_name = $self->doc_root_name();
    my $body =
      $view->render(
        { root_name => $root_name, root => $self->base_root, paths => $self->paths( $path_info ) }
      );
    return [
        200,
        [
            'Content-Type'   => 'text/html',
            'Content-Length' => length $body,
        ],
        [$body]
    ];
}

sub paths {
    my ( $self, $path_info ) = @_;
    my @paths = split '/', $path_info;
    @paths = grep { $_ ne '' } @paths;
    return \@paths;
}

sub doc_root_name {
    my $self = shift;
    my $path = $self->doc_root->absolute;
    my @dir = split '/', $path;
    my $name = pop @dir;
    return $name;
}

sub serve_static {
    my ( $self, $path_info ) = @_;
    $path_info =~ s!/podder_static!/static!;
    my $body = $self->base_root->file( $path_info )->slurp;
    return [ 200, [ 'Content-Length' => length $body ], [$body] ];
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Podder - Cool and Easy standalone viewer of Perl codes and Pods.

=head1 SYNOPSIS

  # in your .psgi
  use Podder;

  my $podder = Podder->new( doc_root => './' );
  $podder->handler;

=head1 DESCRIPTION

Podder is Cool and Easy standalone viewer of Perl codes and Pods.
Using Plack and Blueprint css framework.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

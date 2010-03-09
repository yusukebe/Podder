package Podder::Dispatcher;
use Mouse;

has 'doc_root' => ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );

sub dir_diff {
    my $self = shift;
    $self->doc_root->relative->stringify;
}

sub dispatch {
    my ( $self, $req ) = @_;
    return $self->dispatch_method($req) if $req->param('method');
    my $path_info = $req->path_info;
    return if -f $self->doc_root->file($path_info)->stringify;
    my $c;
    eval {
        if ( $self->doc_root->file($path_info)->slurp() )
        {
            require Podder::File;
            $c =
              Podder::File->new( $self->doc_root->file($path_info), $self->dir_diff );
        }
        else {
            require Podder::Dir;
            $c = Podder::Dir->new( $self->doc_root->subdir($path_info),
                $self->dir_diff );
        }
    };
    if ($@){
        warn $@;
        return;
    }
    return $c->stash;
}

sub dispatch_method {
    my ( $self, $req ) = @_;
    my $c;
    if( $req->param('method') eq 'perldoc' ){
        require Podder::Method::Perldoc;
        $c = Podder::Method::Perldoc->new( query => $req->param('query') );
    }
    return $c->stash if $c;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

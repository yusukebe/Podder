package Podder::Search;
use Mouse;
use Pod::Simple::Search;

has 'searcher' => (
    is      => 'ro',
    isa     => 'Pod::Simple::Search',
    default => sub {
        Pod::Simple::Search->new;
    }
);

has 'query' => ( is => 'rw', isa => 'Str', default => '' );

sub render {
    my ($self, $query) = @_;
    my $locale = $search->find( $self->query );
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

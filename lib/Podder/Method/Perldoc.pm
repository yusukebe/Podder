package Podder::Method::Perldoc;
use Mouse;
with 'Podder::Role';
use Pod::Simple::Search;

has 'searcher' => (
    is      => 'ro',
    isa     => 'Pod::Simple::Search',
    default => sub {
        Pod::Simple::Search->new;
    }
);

has 'query' => ( is => 'rw', isa => 'Str', required => 1 );

sub stash {
    my $self   = shift;
    my $locale = $self->searcher->find( $self->query );
    my $pod;
    $pod = $self->pod2html($locale) if $locale;
    return {
        template => 'file.tt2',
        title    => $self->query,
        pod      => $pod,
        current  => "perldoc " . $self->query,    #XXX
    };
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

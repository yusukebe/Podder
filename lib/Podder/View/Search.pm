package Podder::View::Search;
use Mouse;
with 'Podder::View';
use Pod::Simple::Search;

has 'searcher' => (
    is      => 'ro',
    isa     => 'Pod::Simple::Search',
    default => sub {
        Pod::Simple::Search->new;
    }
);

has 'query' => ( is => 'rw', isa => 'Str', required => 1 );

sub render {
    my ($self, $params) = @_;
    my $locale = $self->searcher->find( $self->query );
    my $pod;
    $pod = $self->pod2html( $locale ) if $locale;
    $self->render_tt(
        'file.tt2',
        {
            title   => $self->query,
            pod     => $pod,
            current => "perldoc " . $self->query, #xxx
            %$params,
        }
    );
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;

package Podder::View;
use Mouse;
use Template;

sub render {
    my ( $self, $args ) = @_;
    my $config = {
        INCLUDE_PATH => $args->{root}->subdir('tmpl'),
        WRAPPER  => 'base.tt2',
    };
    $args->{current} = pop @{$args->{paths}} unless $args->{current};
    my $template = Template->new($config);
    my $body;
    $template->process( $args->{template}, $args, \$body )
      || Carp::croak( $template->error() );
    return $body;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;


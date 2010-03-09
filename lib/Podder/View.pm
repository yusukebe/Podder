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
    eval{
        $template->process( $args->{template}, $args, \$body )
    };
    return if $@;
    return $body;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;


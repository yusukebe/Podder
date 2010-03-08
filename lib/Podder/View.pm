package Podder::View;
use Mouse::Role;
use MouseX::Types::Path::Class;
use Template;
use DateTime;
use DateTime::TimeZone::Local;

sub render_tt {
    my ( $self, $filename, $args ) = @_;
    my $config = {
        INCLUDE_PATH => $args->{root}->subdir('tmpl'),
        WRAPPER  => 'base.tt2',
    };
    $args->{current} = pop @{$args->{parents}};
    my $template = Template->new($config);
    my $body;
    $template->process( $filename, $args, \$body )
      || Carp::croak( $template->error() );
    return $body;
}

sub modified_date {
    my ( $self, $stat ) = @_;
    my $dt = DateTime->from_epoch( epoch => $stat->mtime);
    my $tz = DateTime::TimeZone::Local->TimeZone();
    $dt->set_time_zone( $tz );
    return $dt;
}

no Mouse::Role;
1;

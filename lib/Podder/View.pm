package Podder::View;
use Mouse::Role;
use MouseX::Types::Path::Class;
use Template;
use Path::Class qw( dir );
use DateTime;
use DateTime::TimeZone::Local;

has 'include_path' => (
    is       => 'rw',
    isa      => 'Path::Class::Dir',
    required => 1,
    coerce   => 1,
    default  => sub {
        #xxx
        my $dir = dir( $INC{'Podder.pm'} );
        return $dir->parent->parent->subdir('tmpl');
    }
);

sub render_tt {
    my ( $self, $filename, $args ) = @_;
    my $config = {
        INCLUDE_PATH => $self->include_path,
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

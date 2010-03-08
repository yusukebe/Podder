package Podder::View;
use Mouse::Role;
use Template;
use DateTime;
use DateTime::TimeZone::Local;

sub render_tt {
    my ( $self, $filename, $args ) = @_;
    my $config = {
        INCLUDE_PATH => $args->{root}->subdir('tmpl'),
        WRAPPER  => 'base.tt2',
    };
    $args->{current} = pop @{$args->{paths}} unless $args->{current};
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

sub highlight {
    my ( $self, $text ) = @_;
    require Text::VimColor;
    my $syntax = Text::VimColor->new(
        string     => $text,
        filetype => 'perl', #xxx
    );
    return $syntax->html;
}

sub pod2html {
    my ( $self, $file ) = @_;
    require Pod::Simple::XHTML;
    my $parser = Pod::Simple::XHTML->new();
    my $body;
    $parser->output_string( \$body );
    $parser->html_header('');
    $parser->html_footer('');
    $parser->html_h_level(3);
    $parser->parse_file( $file );
    return $body;
}

no Mouse::Role;
1;

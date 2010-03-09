package Podder::Role;
use Mouse::Role;
use DateTime;
use DateTime::TimeZone::Local;
use Path::Class qw( file );
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

sub inao2html {
    my ( $self, $file ) = @_;
    eval {
        require Acme::Text::Inao;
    };
    return if $@;
    my $text = file( $file )->slurp;
    require Encode;
    my $html = Acme::Text::Inao->new->from_inao( Encode::decode( 'utf8',$text ) )->to_html();
    Encode::encode('utf8', $html);
}

no Mouse::Role;
1;

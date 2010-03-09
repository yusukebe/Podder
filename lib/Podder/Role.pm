package Podder::Role;
use Mouse::Role;
use DateTime;
use DateTime::TimeZone::Local;
use Path::Class qw( file );
use Encode;

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
    $file = file ($file) unless ref $file eq 'Path::Class::File';
    require Pod::Simple::XHTML;
    my $parser = Pod::Simple::XHTML->new();
    my $html;
    $parser->output_string( \$html );
    $parser->html_header('');
    $parser->html_footer('');
    $parser->html_h_level(3);
    my @documents = map { Encode::decode('utf8',$_) } $file->slurp;
    $parser->parse_string_document( @documents );
    return $html;
}

sub inao2html {
    my ( $self, $file ) = @_;
    #XXX
    my $html;
    eval {
        my $text = $file->slurp;
        require Acme::Text::Inao;
        my $html = Acme::Text::Inao->new->from_inao( Encode::decode( 'utf8',$text ) )->to_html();
        $html = Encode::encode('utf8', $html);
    };
    return $html unless $@;
    return;
}

sub hatena2html {
    my ( $self, $file ) = @_;
    my $html;
    eval {
	require Text::Hatena;
	my $text = join '' , $file->slurp;
	$html = Text::Hatena->parse($text);
    };
    return $html unless $@;
    return;
}

no Mouse::Role;
1;

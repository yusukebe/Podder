package Podder::Dir::Ignore;
use Mouse;

sub ignores {
    my $list = <<END_OF_LIST;
blib
pm_to_blib
.svn
.git
.DS_Store
Thumbs.db
END_OF_LIST
    my @lines = split '\n', $list;
    my @list;
    for my $l ( @lines ){
        next unless $l;
        chop( $l );
        push @list, $l;
    }
    return \@list;
}

sub is_ignore {
    my ( $self, $target ) = @_;
    my @paths = split '/', $target;
    $target = pop @paths;
    my $lines = $self->ignores;
    for my $str ( @$lines ){
        return 1 if $target =~ /$str/;
    }
    return;
}

1;

__DATA__

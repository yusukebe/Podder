package Podder::Dir::Ignore;

sub ignores {
    my $list = <<END_OF_LIST;
\bRCS\b
\bCVS\b
~$
^#
\.old$
^blib
^pm_to_blib
\.gz$
\.svn
\.git
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
1;

__DATA__

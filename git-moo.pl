#!/usr/bin/env perl
#
# Show a nice table representing the differences between
# the local repo and remotes.
#
# It is assumed that there is a direct relationship between
# the local branch names and remote branch names.
#
# TODO
#   * always draw local column left of all the remotes
#   * optionally use 256 colors
#   * read colors from .gitconfig
#   * show remote HEADs?
#
# by @drewfish https://gist.github.com/3241991 modified at line 197


use strict;
use warnings;
use Cwd;

# C=color, G=graphic
our $Cgrey  = "\e[30;1m";
our $Cred   = "\e[31m";
our $Cgreen = "\e[32m";
our $Cyel   = "\e[33m";
our $Cblue  = "\e[34m";
our $Cbblue = "\e[34;1m";
our $Cbold  = "\e[37;1m";
our $Cend   = "\e[0m";
our $Gew    = "─";  # east-west
our $Gns    = "│";  # north-south
our $Gnesw  = "┼";  # north-east-south-west
our $Gtrack = "=";

sub git_commits_abbrev {
    my $table = shift || die;

    my $len = 6;
    while ( 1 ) {
        my %commits;    # dedupe
        foreach my $rowname ( keys %$table ) {
            foreach my $colname ( keys %{$table->{$rowname}} ) {
                my $commit = $table->{$rowname}{$colname}{'commit'};
                next unless $commit;
                $commits{$commit} = 1;
            }
        }
        my %abbrevs;
        foreach my $commit ( keys %commits ) {
            my $abbrev = substr($commit, 0, $len);
            $abbrevs{$abbrev}++;
        }
        if ( grep { $_ > 1 } values %abbrevs ) {
            $len += 3;
            next;
        }
        last;
    }

    foreach my $rowname ( keys %$table ) {
        foreach my $colname ( keys %{$table->{$rowname}} ) {
            my $commit = $table->{$rowname}{$colname}{'commit'};
            next unless $commit;
            $table->{$rowname}{$colname}{'commit'} = substr($commit, 0, $len);
        }
    }
}


sub git_distance {
    my $refa = shift || die;
    my $refb = shift || die;
    return undef if $refa eq $refb;

    my $log = `git rev-list --left-right --count $refa...$refb`;
    return undef unless $log =~ m/^(\d+)\s+(\d+)/;
    return {
        'pos' => $1,
        'neg' => $2,
    };
}


sub table_draw {
    my $table   = shift || die; # hashref row (branch) => colum (remote) => hashref details

    my %colwidths;  # column => max width;
    $colwidths{'--ROWNAMES--'} = 0;
    foreach my $rowname ( keys %$table ) {
        my $text = table_cell_draw({ branch => $rowname });
        my $len = length $text;
        $colwidths{'--ROWNAMES--'} ||= 0;
        $colwidths{'--ROWNAMES--'} = $len if $colwidths{'--ROWNAMES--'} < $len;

        foreach my $colname ( keys %{$table->{$rowname}} ) {
            my $text = table_cell_draw($table->{$rowname}{$colname});
            my $len = length $text;
            $colwidths{$colname} ||= 0;
            $colwidths{$colname} = $len if $colwidths{$colname} < $len;
        }
    }

    # draw headers
    my %row = map { $_ => { remote => $_ } } keys %colwidths;
    table_row_draw('--ROWNAMES--', \%row, \%colwidths);

    # draw horizontal line
    print $Cgrey, ($Gew x ($colwidths{'--ROWNAMES--'} + 2));
    print $Gnesw, ($Gew x ($colwidths{'local'} + 2));
    foreach my $col ( sort keys %colwidths ) {
        next if $col eq '--ROWNAMES--';
        next if $col eq 'local';
        print $Gnesw, ($Gew x ($colwidths{$col} + 2));
    }
    print $Cend, "\n";

    # draw rows
    foreach my $rowname ( sort keys %$table ) {
        table_row_draw($rowname, $table->{$rowname}, \%colwidths);
    }
}


sub table_cell_draw {
    my $cell = shift || {};     # hashref
    my $width = shift;          # integer, also signifies to use color
    my $text = '';
    my $len = 0;

    if ( $cell->{'remote'} ) {
        $text = $cell->{'remote'};
        $len = length $text;
        if ( $width ) {
            $text = "$Cbold$text$Cend";
        }
    }

    if ( $cell->{'branch'} ) {
        $text = $cell->{'branch'};
        $len = length $text;
        if ( $width and $cell->{'local'} ) {
            $text = "$Cbblue$text$Cend";
        }
    }

    if ( $cell->{'commit'} ) {
        $text = $cell->{'commit'};
        $len = length $text;
        if ( $width and $cell->{'local'} ) {
            $text = "$Cblue$text$Cend";
        }
        if ( $width and $cell->{'up-to-date'} ) {
            $text = "$Cgrey$text$Cend";
        }

        if ( $cell->{'track'} ) {
            my $deco = ' ' . $Gtrack;
            $len += length $deco;
            if ( $width ) {
                $deco = " $Cblue$Gtrack$Cend";
            }
            $text .= $deco;
        }

        if ( $cell->{'distance'} ) {
            my $deco = ' ';
            $deco .= '+' . $cell->{'distance'}{'pos'} if $cell->{'distance'}{'pos'};
            $deco .= '-' . $cell->{'distance'}{'neg'} if $cell->{'distance'}{'neg'};
            $len += length $deco;
            if ( $width ) {
                $deco = ' ';
                $deco .= "$Cgreen+" . $cell->{'distance'}{'pos'} . $Cend if $cell->{'distance'}{'pos'};
                $deco .= "$Cred-" . $cell->{'distance'}{'neg'} . $Cend if $cell->{'distance'}{'neg'};
            }
            $text .= $deco;
        }
    }
    my $pad = '';
    $pad = ' ' x ($width - $len) if $width;
    return $text . $pad;
}


sub table_row_draw {
    my $rowname     = shift || die; # string
    my $row         = shift || die; # hashref cols => details
    my $colwidths   = shift || die; # hashref cols => widths

    my $cell = {
        branch => $rowname,
        local => $row->{'local'}{'commit'},
    };

    if ('--ROWNAMES--' eq $rowname) {
        $cell = {};
    } elsif (not $cell->{'local'} and not scalar @ARGV) {
        # show only local refs unless -v. TODO use real param
        return;
    }

    print ' ', table_cell_draw($cell, $colwidths->{'--ROWNAMES--'}), ' ';

    print "$Cgrey$Gns$Cend ", table_cell_draw($row->{'local'}, $colwidths->{'local'}), ' ';
    foreach my $colname ( sort keys %$colwidths ) {
        next if $colname eq '--ROWNAMES--';
        next if $colname eq 'local';
        print "$Cgrey$Gns$Cend ", table_cell_draw($row->{$colname}, $colwidths->{$colname}), ' ';
    }

    print "\n";
}


sub main {
    my %table;  # row (branch) => column (remote) => hashref details

    my $log = `git for-each-ref --format='%(refname) %(objectname) %(upstream)'`;
    foreach my $line ( split "\n", $log ) {
        my($refname, $commit, $upstream) = split ' ', $line;
        if ( $refname =~ m#^refs/heads/([^/]+)$# ) {
            my $branch = $1;
            $table{$branch}{'local'}{'commit'} = $commit;
            $table{$branch}{'local'}{'local'} = 1;
            if ( $upstream =~ m#^refs/remotes/([^/]+)/\Q$branch\E$# ) {
                my $remote = $1;
                $table{$branch}{$remote}{'track'} = 1;
            }
            next;
        }
        if ( $refname =~ m#^refs/remotes/([^/]+)/([^/]+)$# ) {
            my $remote = $1;
            my $branch = $2;
            # TODO: show remote HEADs?
            next if $branch eq 'HEAD';
            $table{$branch}{$remote}{'commit'} = $commit;
            if ( $table{$branch}{'local'}{'commit'} and $table{$branch}{'local'}{'commit'} eq $table{$branch}{$remote}{'commit'} ) {
                $table{$branch}{$remote}{'up-to-date'} = 1;
            }
            next;
        }
    }

    foreach my $branch ( keys %table ) {
        next unless $table{$branch}{'local'}{'commit'};
        foreach my $remote ( keys %{$table{$branch}} ) {
            next if $remote eq 'local';
            my $distance = git_distance($table{$branch}{$remote}{'commit'}, $table{$branch}{'local'}{'commit'});
            $table{$branch}{$remote}{'distance'} = $distance if $distance;
        }
    }

    git_commits_abbrev(\%table);

    table_draw(\%table);
}

main();

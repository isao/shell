#!/usr/bin/perl
# 
# dict -- Perl DICT system client
# 
# Created: Thu Apr 17 19:49:15 1997 by bamartin@miranda.org
# Revised: Thu Mar 12 02:00:44 1998 by bamartin@miranda.org
# Copyright 1997-1998 Bret A. Martin (bamartin@miranda.org)
# This program comes with ABSOLUTELY NO WARRANTY.
# 
#
#   The contents of this file are subject to the Netscape Public License
#   Version 1.0 (the "NPL"); you may not use this file except in compliance
#   with the NPL. You may obtain a copy of the NPL at
#   http://www.mozilla.org/NPL/
#
#   Software distributed under the NPL is distributed on an "AS IS" basis,
#   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the NPL
#   for the specific language governing rights and limitations under the
#   NPL.
#
#   The Initial Developer of this code under the NPL is Bret Martin.
#
#
# $Id: dict.pl,v 1.1 2005/04/08 22:11:58 isao Exp $
# 

require 5.002;
use File::Basename;
use FileHandle;
use Socket;

$me = basename $0;
chop($hostname = `hostname`);

$server = "dict.org";
$port   = 2628;

sub usage {
    print STDERR <<EOM;
usage: $me [options] [word]
  valid options: -d database            use database <database>
                 -m strategy            use matching strategy <strategy>
                 -i database            get information on <database>
                 -D                     list available databases
                 -M                     list matching methods
                 -I                     show server information
                 -s server[:port]       specify server (and optional port)
                                        default is $server:$port
                 -v                     verbose (for debugging)
EOM
    exit(1);
}

if ($#ARGV < 0) { &usage; }

push(@cmdlist, "CLIENT perl-dict\@$hostname");

while ($arg = shift @ARGV) {
    if    ($arg eq "-d") { $opt_d = shift @ARGV; }
    elsif ($arg eq "-m") { 
        $opt_m = shift @ARGV;
        push(@cmdlist, "SHOW DATABASES");  # need DB list for header
    }
    elsif ($arg eq "-D") { push(@cmdlist, "SHOW DATABASES");   $opt_D = 1; }
    elsif ($arg eq "-M") { push(@cmdlist, "SHOW STRATEGIES");  $opt_M = 1; }
    elsif ($arg eq "-I") { push(@cmdlist, "SHOW SERVER");      $opt_I = 1; }
    elsif ($arg eq "-h") { $opt_h = shift @ARGV; }
    elsif ($arg eq "-v") { $opt_v = 1; }
    elsif ($arg eq "-i") { 
	$opt_i = shift @ARGV;
	push(@cmdlist, "SHOW DATABASES");  # need DB list for header
	push(@cmdlist, "SHOW INFO $opt_i");
    } else {
	if ($opt_m ne "") {
	    push(@cmdlist, "MATCH " .
		 ($opt_d eq "" ? '*' : $opt_d) .
		 " $opt_m  \"$arg\"");
	} else {
	    push(@cmdlist, "DEFINE " .
		 ($opt_d eq "" ? '*' : $opt_d) .
		 " \"$arg\"");
	}
    }
}

if ($opt_h ne "") {                        # handle -h command line option
    if ($opt_h =~ /:/) { ($server,$port) = split(/:/, $opt_h); } 
    else { $server = $opt_h; }
}

push(@cmdlist, "QUIT");

#$iaddr  = inet_aton($server)               || die "server not found";
#$paddr  = sockaddr_in($port, $iaddr);
($name, $aliases, $type, $len, $iaddr) = gethostbyname($server);
($opt_v) && printf "Server %s => %s\n", $server, $name;
$sockaddr = 'S n a4 x8';
$paddr = pack( $sockaddr, AF_INET, $port, $iaddr );

$proto  = getprotobyname('tcp');

socket(SOCK, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";
connect(SOCK, $paddr)                      || die "connect: $!";

select(SOCK); $| = 1; select(STDOUT); $| = 1;

foreach $i (@cmdlist) {
    print SOCK "$i\r\n";
    $opt_v && print "client sends: $i\n";
}

$n = $#cmdlist; $data = $buf = "";

while ($buf !~ /221 /) {                   # while connection is open
    recv(SOCK, $buf, 4096, 0);             # receive data from socket
    $data = $data . $buf;                  # and append it to stored data
}

$data =~ s/\r\n\r\n/\r\n \r\n/g;
@data = split(/\r\n/,$data);
@data = reverse @data;

while ($line = pop @data) {
    if ($line =~ /^(\d{3}) (.+)$/) {
	$tail = $2;
	for ($1) {
	    /110/ and do {          # database list
		while (($line = pop @data) !~ /^\.$/) {
		    $line =~ /^(\S+) \"(.+)\"/;
		    $db = $1; $name = $2;
		    $dbs{$db} = $name;
		}

		if ($opt_D) {
		    $- = 0;
		    STDOUT->format_name("DB");
		    STDOUT->format_top_name("DB_TOP");
		    foreach $db (keys %dbs) {
			write;
		    }
		}

		last;
	    };

	    /111/ and do {          # strategy list
		while (($line = pop @data) !~ /^\.$/) {
		    $line =~ /^(\S+) \"(.+)\"/;
		    $strat = $1; $name = $2;
		    $strats{$strat} = $name;
		}
		
		if ($opt_M) {
		    $- = 0;
		    STDOUT->format_name("STRAT");
		    STDOUT->format_top_name("STRAT_TOP");
		    foreach $strat (keys %strats) {
			write;
		    }
		}
		
		last;
	    };
	    
	    /112/ and do {          # database info
		print "*** Database information on \"$dbs{$opt_i}\" ***\n";
		last;
	    };

	    /113/ and do {          # help text
		print "*** Server/protocol help text ***\n";
		last;
	    };

            /114/ and do {          # server info
		print "*** Server information for $server:$port ***\n";
		last;
	    };
	    
	    /130|210|220|221|230|250|330/ and do {
		# 130 challenge follows
		# 210 open connection
		# 220 text msg-id
		# 221 closing connection
		# 230 authentication successful
		# 250 command complete
		# 330 challenge response

		($opt_v) &&
		  print STDERR "server sends: $line\n";
		last;
	    };

	    /150/ and do {          # definitions found
		($num,$trash) = split(/ /,$tail);
		print "$num definition" . 
		    (($num==1) ? "" : "s") . " found\n\n";
		last;
	    };

	    /151/ and do {          # definition follows
		$tail =~ /"(.+)" (.+) "(.+)"/;
		$db = $2;
		print "*** Source: $3 ***\n";
		last;
	    };

	    /152/ and do {          # matches found
	        ($num,$trash) = split(/ /,$tail);
		print "$num match" .
		    (($num==1) ? "" : "es"). " found\n";
		$matching = 1;
		last;
	    };

	    /420|421/ and do {      # server transitional errors
		# 420 Server temporarily unavailable
		# 421 Server shutting down

		print STDERR "DICT server: $line\n";
		last;
	    };

	    /500|501|502|503|530|531|532|550|551|552|554|555/ and do {
		# 500 bad command, 501 bad parameters,
		# 502 command not implemented, 503 parameter not implemented,
		# 530/531/532 authentication failed,
		# 550 invalid database, 551invalid strategy, 
		# 552 no matches found
		# 554 no databases present, 555 no strategies available
		
		print STDERR "DICT error: $line\n";
		last;
	    };
	}

    } elsif ($line =~ /^\.$/) {
	print "\n";
    } elsif ($matching == 1) {
	$line =~ /^(\S+) \"(.+)\"$/;
	if ($1 ne $curdb) {
	    $curdb = $1;
	    print "\n*** Source: $dbs{$curdb} ***\n";
	}
	$cow = $query = $2;
	print "\t$cow\n";
    } else {
	print "$line\n";
    }
}

close(SOCK)                                || die "close: $!";
exit(0);


format DB_TOP = 
short name      description
----------      -----------
.

format DB =
@<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$db, $dbs{$db}
.

format STRAT_TOP = 
method name     description
-----------     -----------
.

format STRAT =
@<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$strat, $strats{$strat}
.


__END__

=head1 NAME

dict - perl client for the DICT protocol described in RFC 2229

=head1 SYNOPSIS

dict [B<-d> I<database>] [B<-m> I<strategy>] [B<-i> I<database>]
     [B<-D>] [B<-M>] [B<-I>] [B<-h> I<server>[:I<port>]] [B<-v>] [I<word> ...]

=head1 DESCRIPTION

B<dict> is a client for the DICT protocol described in RFC 2229.  DICT
is a protocol that allows a client to access dictionary definitions
from a set of natural language dictionary databases.  More informatin
on the DICT project is available at http://www.dict.org/ .

Every DICT server has a set of databases and a set of matching
strategies.  Unless otherwise specified (with the B<-m> option and a
matching I<strategy>), B<dict> will request definitions of I<word>s
specified on the command line.

=head2 OPTIONS

=item B<-d> I<database>

Use I<database> for this query.  (Obtain a list of I<database>s with
B<dict -D>.)  Without this option, all I<databases> will be searched.

=item B<-m> I<strategy>

Use I<strategy> for this query.  (Obtain a list of I<strategies> with
B<dict -M>.)  With this option, the default behavior (returning
definitons) is overridden and a list of words matching the query
I<word> using the specified I<strategy> is returned.

=item B<-i> I<database>

Ask the server for information on I<database>.

=item B<-D>

Get a list of available I<database>s and their full names.

=item B<-M>

Get a list of available matching I<strategies>.

=item B<-h> I<server>[:I<port>]

Override the default I<server> (and optionally I<port>).

=item B<-v>

Be verbose about the DICT transaction.  This is really only useful for
debugging.

=head1 AUTHOR

Bret A. Martin (bamartin@miranda.org).

=head1 BUGS

B<dict> does not implement the AUTH command and associated
functionality for authentication as specified in RFC 2229.

=head1 COPYRIGHT

Copyright 1997-1998 Bret A. Martin (bamartin@miranda.org).

This program is subject to the Netscape Public License Version 1.0
(the "NPL"); you may not use this file except in compliance with the
NPL. You may obtain a copy of the NPL at http://www.mozilla.org/NPL/

Software distributed under the NPL is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the NPL
for the specific language governing rights and limitations under the
NPL.

The Initial Developer of this code under the NPL is Netscape
Communications Corporation. Portions created by the Initial Developer
are Copyright 1997-1998 Bret A. Martin. All Rights Reserved.


7. DISCLAIMER OF WARRANTY.

THE COVERED WORKS ARE PROVIDED UNDER THIS LICENSE ON AN ``AS IS''
BASIS, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
INCLUDING, WITHOUT LIMITATION, WARRANTIES THAT THE COVERED WORKS ARE
FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE OR
NON-INFRINGING. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF
THE COVERED WORKS IS WITH YOU. SHOULD ANY COVERED WORK PROVE DEFECTIVE
IN ANY RESPECT, YOU (NOT THE INITIAL DEVELOPER OR ANY OTHER
CONTRIBUTOR) ASSUME THE COST OF ANY NECESSARY SERVICING, REPAIR OR
CORRECTION. THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL PART
OF THIS LICENSE. NO USE OF ANY COVERED WORK IS AUTHORIZED HEREUNDER
EXCEPT UNDER THIS DISCLAIMER.

9. LIMITATION OF LIABILITY.

UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL THEORY, WHETHER TORT
(INCLUDING NEGLIGENCE), CONTRACT, OR OTHERWISE, SHALL THE INITIAL
DEVELOPER, ANY OTHER CONTRIBUTOR, OR ANY DISTRIBUTOR OF A COVERED
WORK, OR ANY SUPPLIER OF ANY OF SUCH PARTIES, BE LIABLE TO YOU OR ANY
OTHER PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES OF ANY CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR
LOSS OF GOODWILL, WORK STOPPAGE, COMPUTER FAILURE OR MALFUNCTION, OR
ANY AND ALL OTHER COMMERCIAL DAMAGES OR LOSSES, EVEN IF SUCH PARTY
SHALL HAVE BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES. THIS
LIMITATION OF LIABILITY SHALL NOT APPLY TO LIABILITY FOR DEATH OR
PERSONAL INJURY RESULTING FROM SUCH PARTY'S NEGLIGENCE TO THE EXTENT
APPLICABLE LAW PROHIBITS SUCH LIMITATION. SOME JURISDICTIONS DO NOT
ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR CONSEQUENTIAL
DAMAGES, SO THAT EXCLUSION AND LIMITATION MAY NOT APPLY TO YOU.

10. U.S. GOVERNMENT END USERS.

Each Covered Work is a ``commercial item,'' as that term is defined in
48 C.F.R. 2.101 (Oct. 1995), consisting of ``commercial computer
software'' and ``commercial computer software documentation,'' as such
terms are used in 48 C.F.R. 12.212 (Sept. 1995). Consistent with 48
C.F.R. 12.212 and 48 C.F.R. 227.7202-1 through 227.7202-4 (June 1995),
all U.S. Government End Users acquire Covered Works with only those
rights set forth herein.

=cut

#!/usr/bin/env php
<?php
/*
  usage: svn log | svn-stats.php [-l]

  (any command line argument will sort by lines rather than commits)
  sample:

     users  cmt	  loc (sorted by commits)
    *total  2041	7217
      isao  481	  5118
    mrsfoo  391	  410
   mrbobby  343	  659
   ..etc
*/

function get_stats($file) {
  $first = array('commits' => 1, 'lines' => 1);
  $stats = array('*sum' => $first);

  foreach(file($file) as $line) {
    //r5887 | buildmob | 2011-08-23 13:08:25 -0700 (Tue, 23 Aug 2011) | 4 lines

    if(count(list($r, $u, $d, $n) = explode(' | ', $line)) < 4) {
    	continue;
    }

    if($stats[$u]) {
      $stats[$u]['commits']++;
      $stats[$u]['lines'] += (int) $n;
      $stats['*sum']['commits']++;
      $stats['*sum']['lines'] += (int) $n;

    } else {
      $stats[$u] = $first;
    }
  }
  return $stats;
};

function print_stats(array $stats, $sortby) {
  print "users    commits  commit%  lines    line%  (sorted by $sortby)\n";
  print "-------  -------  -------  -----  -------\n";

  uasort($stats, function($a, $b) use($sortby) {
    return $b[$sortby] - $a[$sortby];
  });

	foreach($stats as $user => $stat) {
	  printf(
	    "% -10s% 6d% 8.1f%%% 7d% 8.1f%%\n"
	    , $user
	    , $stat['commits']
	    , $stat['commits']/$stats['*sum']['commits']*100
	    , $stat['lines']
	    , $stat['lines']/$stats['*sum']['lines']*100
	  );
  }
  print "\n";
}

print_stats(get_stats('php://stdin'), $argc > 1 ? 'lines' : 'commits');

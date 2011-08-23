<?php
/*
  usage: svn log | svn-stats.php [-l]

  (any command line argument will sort by lines rather than commits)
  sample:

     users  cmt	loc (sorted by commits)
      isao  481	5118
    mrsfoo  391	410
   mrbobby  343	659
   ..etc
*/

function get_stats() {
  $stats = array();
  $first = array('commits' => 1, 'lines' => 1);

  foreach(file('php://stdin') as $line) {
    //r5887 | buildmob | 2011-08-23 13:08:25 -0700 (Tue, 23 Aug 2011) | 4 lines
    list($r, $u, $d, $n) = explode(' | ', $line);

    if($stats[$u]) {
      $stats[$u]['commits']++;
      $stats[$u]['lines'] += (int) $n;
    } else {
      $stats[$u] = $first;
    }
  }
  return $stats;
};

function print_stats(array $stats, $sortby) {
  printf("% 10s  %s\t%s (sorted by %s)\n", 'users', 'cmt', 'loc', $sortby);

  uasort($stats, function($a, $b) use($sortby) {
    return $b[$sortby] - $a[$sortby];
  });

	foreach($stats as $user => $stat) {
	  printf(
	    "% 10s  %d\t%d\n"
	    , $user, $stat['commits'], $stat['lines']
	  );
  }
  print "\n";
}

$stats = get_stats();
print_stats($stats, $argc > 1 ? 'lines' : 'commits');

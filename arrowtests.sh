#!/bin/sh -e

# usage: $0 [optional arrow args]
# run all arrow tests from cwd and just display the results

err() {
    echo "error: $2" >&2
    exit $1
}

which pgrep arrow java >/dev/null || err 1 'missing prerequisites'
pgrep -fq arrow_server selenium || err 3 'daemons not running'

logf=/dev/null
opts=" --driver=nodejs --browser=phantomjs --logLevel=ERROR $@"

find . -name '*descriptor.json' | xargs -tn1 \
    arrow $opts | tee $logf | egrep '^ |..32m[0-9]+'

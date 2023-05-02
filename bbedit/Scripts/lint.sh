#!/bin/bash -e

is_package_root() {
    [ -f package.json ] || [ -d .git ]
}

package_root_dir() {(
    local lastPwd
    while ! is_package_root && [ "$lastPwd" != "$PWD" ]
    do
        lastPwd="$PWD"
        cd ..
    done
    is_package_root && pwd
)}

git_repo_root_dir() {
    git rev-parse --show-toplevel 2>/dev/null
}

# First change to the BBEdit document's directory.
#
cd "$(realpath "$(dirname "$BB_DOC_PATH")")"

# old way
#repoPath=$(git_repo_root_dir)
#[[ -d $repoPath ]] && cd "$repoPath"

# Then change to the document's
packageRootDir=$(package_root_dir)
[[ -d "$packageRootDir" ]] && cd "$(package_root_dir)"

case "$BB_DOC_PATH" in

    *.bash | *.sh | *.zsh )
        shellcheck --format gcc "$BB_DOC_PATH" | bbresults --pattern gcc
        ;;

    *.css | *.less )
        prettier --loglevel warn --parser css --write "$BB_DOC_PATH"
        ;;

    *.hbs )
        prettier --write --loglevel warn "$BB_DOC_PATH"
        ;;

    *.svelte )
        prettier --write --loglevel warn "$BB_DOC_PATH"
        ;;

    *.js )
        eslint --format unix --fix "$BB_DOC_PATH" | bbresults
        ;;

    *.json | *.json5 )
        prettier --loglevel warn --parser json --write "$BB_DOC_PATH"
        ;;

    *.scss )
        stylelint --formatter unix --fix "$BB_DOC_PATH" | bbresults
        ;;

esac

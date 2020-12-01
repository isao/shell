#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"

case "$BB_DOC_PATH" in

    *.bash | *.sh | *.zsh )
        shellcheck --format gcc "$BB_DOC_PATH" | bbresults --pattern gcc
        ;;

    *.css | *.less )
        prettier --loglevel warn --parser css --write "$BB_DOC_PATH"
        ;;

    *.hbs )
        cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 1
        ember-template-lint "$BB_DOC_PATH"
        # TODO use --json and transform to format compatible with bbresult
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

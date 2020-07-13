#!/bin/sh -e
cd "$(dirname "$BB_DOC_PATH")"

case "$BB_DOC_PATH" in

    *.js )
        eslint --format unix --fix "$BB_DOC_PATH" | bbresults
        ;;

    *.hbs )
        cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 1
        ember-template-lint "$BB_DOC_PATH"
        # TODO use --json and transform to format compatible with bbresult
        ;;

    *.scss )
        stylelint --formatter unix "$BB_DOC_PATH"
        ;;

    *.bash | *.sh | *.zsh )
        shellcheck --format gcc "$BB_DOC_PATH" | bbresults --pattern gcc
        ;;

esac

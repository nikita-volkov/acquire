all: test

format:
	for path in $$(git diff --staged --name-only -- '*.cabal') $$(git ls-files -om --exclude-standard -- '*.cabal'); do if test -f $$path; then cabal-fmt --no-tabular -c $$path 2> /dev/null || cabal-fmt --no-tabular -i $$path; fi; done
	for path in $$(git diff --staged --name-only -- '*.hs') $$(git ls-files -om --exclude-standard -- '*.hs'); do if test -f $$path; then ormolu -ic $$path; fi; done

build: format
	stack build --fast --test --no-run-tests --ghc-options="-j -threaded +RTS -A128m -n2m -RTS -Werror=incomplete-patterns"

test: build clean
	stack build --test

clean:
	stack clean

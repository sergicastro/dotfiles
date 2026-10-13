#!/usr/bin/env bash
#
# Integration tests for templatedir/hooks/pre-push: runs real pushes against a
# local bare remote. Usage: git/test/pre-push-test.sh

HOOK="$(cd "$(dirname "$0")" && pwd)/../templatedir/hooks/pre-push"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

passed=0
failed=0

# Fresh bare remote + clone with the hook installed, one commit pushed to master.
setup() {
    rm -rf "$TMP/remote.git" "$TMP/work"
    git init -q --bare "$TMP/remote.git"
    git init -q -b master "$TMP/work"
    cd "$TMP/work" || exit 1
    git config user.email t@example.com
    git config user.name test
    git config commit.gpgsign false
    git config push.default current
    git config core.hooksPath .git/hooks
    git remote add origin "$TMP/remote.git"
    rm -f .git/hooks/pre-push
    /bin/cp "$HOOK" .git/hooks/pre-push
    git commit -q --allow-empty -m base
    git push -q origin master
}

# Rewrites local history so that pushing master is no longer a fast-forward.
diverge() {
    git commit -q --allow-empty -m second
    git push -q origin master
    git reset -q --hard HEAD~1
    git commit -q --allow-empty -m rewritten
}

# expect allowed|blocked <name> <git push args...>
expect() {
    local want=$1 name=$2 out status
    shift 2
    out=$(git push "$@" 2>&1)
    status=$?
    if [[ $want == allowed && $status -eq 0 ]] ||
       [[ $want == blocked && $status -ne 0 && $out == *"has been rejected"* ]]; then
        passed=$((passed + 1))
        echo "ok   - $name"
    else
        failed=$((failed + 1))
        echo "FAIL - $name (wanted $want, exit $status)"
        echo "$out" | sed 's/^/       /'
    fi
}

setup; git commit -q --allow-empty -m next
expect allowed "fast-forward to master"            origin master

setup; git commit -q --allow-empty -m next
expect allowed "fast-forward with bare 'git push'" origin
expect allowed "no-op push to master"              origin master

setup; git commit -q --allow-empty -m next
expect allowed "new branch"                        origin HEAD:feature
expect allowed "force to unprotected branch"       -f origin HEAD:feature

setup; diverge
expect blocked "master --force"                    origin master --force
expect blocked "master -f"                         -f origin master
expect blocked "master trailing -f"                origin master -f
expect blocked "master --force-with-lease"         origin master --force-with-lease
expect blocked "master +refspec"                   origin +master
expect blocked "master with -u before remote"      -u -f origin master
expect blocked "master via explicit refspec"       origin HEAD:refs/heads/master -f
expect blocked "delete master"                     origin :master
expect allowed "--no-verify bypass"                --no-verify -f origin master

setup; git commit -q --allow-empty -m x; git push -q origin HEAD:main
git reset -q --hard HEAD~1; git commit -q --allow-empty -m y
expect blocked "force to main"                     -f origin HEAD:main
expect blocked "delete main"                       origin :main

setup; git push -q origin HEAD:feature; git commit -q --allow-empty -m x
expect allowed "delete unprotected branch"         origin :feature

setup; git commit -q --allow-empty -m x
expect allowed "feature/master is not protected"   -f origin HEAD:feature/master
expect allowed "tag named master"                  origin HEAD:refs/tags/master
setup; diverge
expect blocked "several refs, one forced master"   -f origin HEAD:feature master:master

# remote has a commit the local clone never fetched
setup; git clone -q "$TMP/remote.git" "$TMP/other"
( cd "$TMP/other" && git config user.email t@example.com && git config user.name test &&
  git commit -q --allow-empty -m theirs && git push -q origin master )
git commit -q --allow-empty -m mine
expect blocked "unfetched remote commits"          origin master

echo
echo "$passed passed, $failed failed"
[[ $failed -eq 0 ]]

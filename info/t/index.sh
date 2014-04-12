#!/bin/sh

. t/Init-test.inc

# Follow an index entry

# TODO: Use AM_TESTS_FD_REDIRECT instead

./pseudotty >pty_file &
PTY_PID=$!
exec >"$(cat pty_file | tr -d '\n')"
rm -f pty_file

echo ${GINFO}

rm -f t/ginfo-output
$GINFO -f intera --restore t/index.drib
kill $PTY_PID

test -f t/ginfo-output || exit 1

# Return non-zero (test failure) if files differ
diff t/ginfo-output t/node-target

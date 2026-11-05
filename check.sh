#!/bin/bash

all_pass=1

for i in 1 2 3 4; do
	dir="Testcase${i}"
	outdir="Testcase${i}Diff"
	ok=1
	any_diff=0

	if [ -d "$dir" ]; then
		for f1 in "$dir"/*.1.txt; do
			[ -f "$f1" ] || continue
			base=$(basename "$f1" .1.txt)
			f2="$dir/${base}.2.txt"
			[ -f "$f2" ] || continue

			outfile="$outdir/${base}Diff.txt"

			diff -u "$f1" "$f2" > /dev/null 2>&1
			status=$?

			if [ $status -eq 1 ]; then

				any_diff=1
				if [ ! -f "$outfile" ]; then
					echo "missing $outfile" >&2
					ok=0
				elif ! cmp -s \
					<(diff -u "$f1" "$f2" | tail -n +3) \
					<(tail -n +3 "$outfile"); then
					echo "contents differ in $outfile" >&2
					ok=0
				fi
			elif [ $status -eq 0 ]; then

				if [ -f "$outfile" ]; then
					echo "unexpected $outfile (pair is identical)" >&2
					ok=0
				fi
			fi
		done
	fi
	if [ "$any_diff" -eq 1 ]; then
		if [ ! -d "$outdir" ]; then
			echo "missing directory $outdir" >&2
			ok=0
		fi
	else
		if [ -d "$outdir" ]; then
			echo "unexpected directory $outdir" >&2
			ok=0
		fi
	fi

	if [ "$ok" -eq 1 ]; then
		echo "Testcase${i}: PASS"
	else
		echo "Testcase${i}: FAIL"
		all_pass=0
	fi
done

if [ "$all_pass" -eq 1 ]; then
	exit 0
else
	exit 1
fi

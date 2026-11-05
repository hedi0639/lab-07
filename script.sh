#!/bin/bash

for i in 1 2 3 4; do
	rm -rf "Testcase${i}Diff"
done

for i in 1 2 3 4; do
	dir="Testcase${i}"
	outdir="Testcase${i}Diff"
	[ -d "$dir" ] || continue

	for f1 in "$dir"/*.1.txt; do
		[ -f "$f1" ] || continue
		base=$(basename "$f1" .1.txt)

		f2="$dir/${base}.2.txt"
		[ -f "$f2" ] || continue

		diff -u "$f1" "$f2" > /dev/null 2>&1
		status=$?
		if [ $status -eq 1 ]; then
			mkdir -p "$outdir"
			diff -u "$f1" "$f2" > "$outdir/${base}Diff.txt"
		fi
	done
done

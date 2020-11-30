#!/usr/bin/env bash

if ! command -v openscad &> /dev/null; then
	echo 'OpenSCAD binary not found on path.'
	exit -1
fi

fileExists() {
	if [ "${force}" != true ] && [ -f "${1}" ]; then
		echo "File ${file} exists but '-f' flag not set -- skipping."

		true
	else
		false
	fi
}

# read params
while test $# != 0; do
	case "$1" in
		-f) force=true ;;
		-o) outDir=$2; shift ;;
		*) extraOptions="${extraOptions} $1" ;;
	esac

	shift
done

outDir=${outDir:=out/stl}
options="--hardwarnings --check-parameters true --check-parameter-ranges true ${extraOptions} ./bb-brix.scad"

# 1x & 2x bricks
for x in 1 2; do
	for y in {1..6}; do
		if [ "${x}" == 2 ] && [ "${y}" == 1 ]; then
			continue
		else
			file="${outDir}/bb-brix_${x}x${y}.stl"

			echo

			if ! fileExists ${file}; then
				echo "Generating ${x}x${y} brick..."
				openscad -o ${file} -D 'action="brick"' -D "x=${x}" -D "y=${y}" ${options}
			fi
		fi
	done
done

# "L" bricks
for x in {2..6}; do
	for y in {2..6}; do
		file="${outDir}/bb-brix_l_${x}x${y}.stl"

		echo

		if ! fileExists ${file}; then
			echo "Generating ${x}x${y} 'L' brick..."
			openscad -o ${file} -D 'action="brick-l"' -D "x=${x}" -D "y=${y}" ${options}
		fi
	done
done

# "T" bricks
for x in 3 5; do
	for y in {2..6}; do
		offset=$(( (${x} + 1) / 2 ))
		file="${outDir}/bb-brix_t_${x}x${y}@${offset}.stl"

		echo

		if ! fileExists ${file}; then
			echo "Generating ${x}x${y}@${offset} 'T' brick..."
			openscad -o ${file} -D 'action="brick-t"' -D "x=${x}" -D "y=${y}" -D "offset=${offset}" ${options}
		fi
	done
done

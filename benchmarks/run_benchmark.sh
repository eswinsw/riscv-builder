#!/bin/bash

if ! [ $(id -u) = 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi
PWD=$(pwd)

usage() {
    echo "Usage:"
    echo "  ./run_benchmark.sh -l|--list"
    echo "  ./run_benchmark.sh [options] <benchmark>"
    echo "-h, --help        show this help"
    echo "-l, --list        list all supported benchmarks"
    echo "--from-source     compile from source instead of using distro's version"
}

have_function() {
	declare -f "$1" >/dev/null
}

list_bm() {
    for i in $(ls suite); do
        echo $i
    done
}

source_buildfile() {
	shopt -u extglob
	if ! source "$@"; then
		echo "$(gettext "Failed to source $1")"
		exit 1
	fi
	shopt -s extglob
}

install_deps() {
    [ ! -z $deps ] && dnf install $deps -y
}

distro_install() {
    dnf install $1 -y
}

create_srcpackage() {
	local TAR_OPT
    [ -d $srcdir ] && return
    [ -d $srcdir ] || mkdir $srcdir
    for file in ${source[@]}; do
        file_name="${file##*/}"
        [ -f $file_name ] || wget $file
        case "$file_name" in
            *tar.gz)  TAR_OPT="-z" ;;
            *tar.bz2) TAR_OPT="-j" ;;
            *tar.xz)  TAR_OPT="-J" ;;
            *tar)     TAR_OPT=""  ;;
            *)        continue;;
        esac
        if ! LANG=C tar -x ${TAR_OPT} -f "$file_name" -C "$srcdir"; then
            echo "$(gettext "Failed to create source package file.")"
            exit 1
        fi
    done
}

while [ $# -gt 0 ]; do
	case "$1" in
		--from-source)   SOURCE=1;;
        -l|--list)       list_bm; exit 0;;
        -h|--help)       usage; exit 0;;

		*)               BMFILE=$1;;
	esac
	shift
done

BMFILE="suite/$BMFILE"
if [[ ! -f $BMFILE ]]; then
	echo "$(gettext "$BMFILE does not exist.")"
	exit 1
else
	source_buildfile "$BMFILE"
fi

[ -z ${distro} ] && SOURCE=1
LOG_FILE=${LOG_FILE:-$PWD/benchmarks/$bmname/results}
startdir="$PWD/benchmarks/$bmname"
srcdir="$startdir/$bmname-src"
pkgdir="$startdir/$bmname-pkg"
mkdir -p $startdir
cd $startdir

if ! [ -f bm_installed ]; then
    install_deps
    if [ -z ${SOURCE} ]; then
        distro_install $distro || exit 1
    else
        create_srcpackage
        cd $srcdir
        if have_function 'install'; then
            mkdir $pkgdir
            build || exit 1
            cd $srcdir
            install
        else
            build || exit 1
            ln -s $(pwd) $pkgdir
        fi
    fi
    cd $startdir
    echo 1 > bm_installed
fi

echo "Starting benchmarking..."
[ ! -z $SOURCE ] && cd $pkgdir
if [ -z $arguments ]; then
    if have_function 'parse_result'; then
        PATH=$pkgdir:$PATH run_benchmark > "$LOG_FILE" 2>&1
        parse_result
    else
        PATH=$pkgdir:$PATH run_benchmark | tee "$LOG_FILE" 2>&1
    fi
else
    for arg in ${arguments[@]}; do
        if have_function 'parse_result'; then
            PATH=$pkgdir:$PATH run_benchmark $arg > "$LOG_FILE-$arg" 2>&1
            parse_result $arg
        else
            PATH=$pkgdir:$PATH run_benchmark $arg | tee "$LOG_FILE-$arg" 2>&1
        fi
    done
fi

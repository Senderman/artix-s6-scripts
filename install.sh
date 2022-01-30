#!/bin/sh
PKG="$1"

DESTDIR="$2"

SVDIR="${DESTDIR}"/etc/s6/sv
ADMINSVDIR="${DESTDIR}"/etc/s6/adminsv
FALLBACKSVDIR="${DESTDIR}"/etc/s6/fallbacksv
CONFDIR="${DESTDIR}"/etc/s6/config

for dir in "$PKG"/*; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        # This needs to go to adminsv and fallbacksv.
        if [ "$dirname" = "mount-filesystems" ]; then
            TOPDIR="${ADMINSVDIR}"
        else
            TOPDIR="${SVDIR}"
        fi
        for subdir in "$dir"/*; do
            if [ -d "$subdir" ]; then
                subdirname=$(basename "$subdir")
                install -v -d "${TOPDIR}"/"$dirname"/"$subdirname"
                for file in "$subdir"/*; do
                    install -v -m644 "$file" "${TOPDIR}"/"$dirname"/"$subdirname"
                done
            fi
        done
        install -v -d "${TOPDIR}"/"$dirname"
        for file in "$dir"/*; do
            install -v -m644 "$file" "${TOPDIR}"/"$dirname"
        done
        if [ "${TOPDIR}" = "${ADMINSVDIR}" ]; then
            install -v -d "${FALLBACKSVDIR}"/"$dirname"
            cp -ar "${TOPDIR}/$dirname" "${FALLBACKSVDIR}/$dirname"
        fi
    fi
done

for conf in "$PKG"/*.conf; do
        if [ -e "$conf" ]; then
                install -v -d "${CONFDIR}"
                install -v -m644 "$conf" "${CONFDIR}"/"$PKG".conf
        fi
done


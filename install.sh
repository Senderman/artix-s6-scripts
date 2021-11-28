#!/bin/sh

PKG="$1"
DESTDIR="$2"
SVDIR="${DESTDIR}"/etc/s6/sv
CONFDIR="${DESTDIR}"/etc/s6/config

for dir in "$PKG"/*; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        install -v -d "${SVDIR}/$dirname"
        for file in "$dir"/*; do
            install -v -m644 "$file" "${SVDIR}/$dirname"
        done
    fi
done

for conf in "$PKG"/*.conf; do
    install -v -d "${CONFDIR}"
    filename=$(basename "$conf")
    install -v -m644 "$conf" "${CONFDIR}/$filename"
done


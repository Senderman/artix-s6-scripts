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

no_configs_found=false
for conf in "$PKG"/*.conf; do
    no_configs_found=true
    install -v -d "${CONFDIR}"
    install -v -m644 "$conf" "${CONFDIR}/$PKG.conf"
    break
done
$no_configs_found && rm -r "${CONFDIR}"

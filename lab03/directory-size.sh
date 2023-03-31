#!/bin/sh
# без флага b, чтобы выводилось в KB, а не в байтах
du -sb "$@" | sed -ne 's/\\/\\\\/;s/"/\\"/g;s/^\([0-9]\+\)\t\(.*\)$/node_directory_size_bytes{directory="\2"} \1/p' > /var/lib/node_exporter/directory-size.prom

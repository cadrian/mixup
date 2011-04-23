#!/bin/bash
#
# Continuous integration on MiXuP.
#
# This script is meant to be put in a crontab.

cd $(dirname $0)
export OUTDIR=$(pwd)/target/site
test -d $OUTDIR || mkdir -p $OUTDIR

status() {
    log=$1
    if tail -n 1 $log | grep -q SUCCESS; then
        echo true
    else
        echo false
    fi
}

status_failures_count() {
    ls -1 $OUTDIR/log-* | tail -n 5 | while read log; do
        $(status $log) || echo failed
    done | wc -l
}

status_icon() {
    case $(status_failures_count) in
        0)
            echo /usr/share/icons/gnome/48x48/status/weather-clear.png
            ;;
        1)
            echo /usr/share/icons/gnome/48x48/status/weather-few-clouds.png
            ;;
        2)
            echo /usr/share/icons/gnome/48x48/status/weather-overcast.png
            ;;
        3)
            echo /usr/share/icons/gnome/48x48/status/weather-showers-scattered.png
            ;;
        4)
            echo /usr/share/icons/gnome/48x48/status/weather-showers.png
            ;;
        *)
            echo /usr/share/icons/gnome/48x48/status/weather-storm.png
            ;;
    esac
}

build_site() {
    running=$1

    icon=$(status_icon)

    echo '<html>'
    if $running; then
        echo '<head>'
        echo '<meta http-equiv="refresh" content="30">'
        echo '</head>'
    fi
    echo '<body>'
    echo
    echo '<h1>MiXuP continuous integration</h1>'
    echo
    echo '<table border="0"><tr><td><img src="file://'$icon'"></td><td>'$(status_failures_count)' failures in the last 5 builds</td></tr></table>'
    echo
    echo '<h2>Build details</h2>'
    echo
    echo '<table border="0">'
    if $running; then
        echo '<tr>'
        echo '<td>'
        echo '<img src="file:///usr/share/icons/gnome/48x48/emblems/emblem-new.png">'
        echo '</td><td colspan="3"><b>Continuous Integration is running</b></td>'
        echo '</tr>'
    fi
    ls -r -1 $OUTDIR/log-* | while read log; do
        echo '<tr>'
        echo '<td>'
        pkg=$(dirname $log)/build$(basename $log | cut -c4-).tgz
        if $(status $log); then
            echo '<img src="file:///usr/share/icons/gnome/48x48/emblems/emblem-default.png">'
        else
            echo '<img src="file:///usr/share/icons/gnome/48x48/emblems/emblem-important.png">'
        fi
        echo '</td>'
        echo '<td><a href="file://'$log'">'$(basename $log | cut -c5-)'</a></td>'
        echo '<td>&nbsp;|&nbsp;</td>'
        if [ -e $pkg ]; then
            echo '<td><a href="file://'$pkg'">Download</a></td>'
        else
            echo '<td><i>(build not available)</i></td>'
        fi
        echo '</tr>'
    done
    echo '</table>'
    echo '</body>'
    echo '</html>'
}

do_ci() {
    build_site true > $OUTDIR/ci.html
    log=$($(pwd)/src/test/eiffel/ci)
    cp $log $OUTDIR/
    buildlog=$OUTDIR/build-$(basename $log)
    if $(pwd)/release/build.sh -clean > $buildlog; then
        pkg=$(grep Done: $buildlog | awk '{print $5}')
        cp $pkg $OUTDIR/build$(basename $log | cut -c4-).tgz
    else
        echo 'Build failed' >> $OUTDIR/$(basename $log)
    fi
    build_site false > $OUTDIR/ci.html
}

if git pull | grep -q 'up-to-date'; then
    case x$1 in
        x-force)
            do_ci
            ;;
    esac
else
    do_ci
fi

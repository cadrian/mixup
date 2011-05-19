#!/bin/bash
#
# Continuous integration on MiXuP.
#
# This script is meant to be put in a crontab.

cd $(dirname $0)
export OUTDIR=${OUTDIR:-$(pwd)/target/site}
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
    ls -1 $OUTDIR/log/log-* | tail -n 5 | while read log; do
        $(status $log) || echo failed
    done | wc -l
}

status_icon() {
    case $(status_failures_count) in
        0)
            echo ci/weather-clear.png
            ;;
        1)
            echo ci/weather-few-clouds.png
            ;;
        2)
            echo ci/weather-overcast.png
            ;;
        3)
            echo ci/weather-showers-scattered.png
            ;;
        4)
            echo ci/weather-showers.png
            ;;
        *)
            echo ci/weather-storm.png
            ;;
    esac
}

build_site() {
    running=$1

    icon=$(status_icon)
    failures_count=$(status_failures_count)

    echo '<html>'
    echo '<head>'
    if $running; then
        echo '<meta http-equiv="refresh" content="30">'
    else
        echo '<meta http-equiv="refresh" content="300">'
    fi
    echo '</head>'
    echo '<body>'
    echo
    echo '<h1>MiXuP continuous integration</h1>'
    echo
    if [ $failures_count -eq 1 ]; then
        echo '<table border="0"><tr><td><img src="'$icon'"></td><td>1 failure in the last 5 builds</td></tr></table>'
    else
        echo '<table border="0"><tr><td><img src="'$icon'"></td><td>'$failures_count' failures in the last 5 builds</td></tr></table>'
    fi
    echo
    echo '<h2>Build details</h2>'
    echo
    echo '<table border="0">'
    if $running; then
        echo '<tr>'
        echo '<td>'
        echo '<img src="ci/running.png"></td>'
        echo '<td colspan="9"><i>Continuous Integration is running</i></td>'
        echo '</tr>'
    fi
    ls -r -1 $OUTDIR/log/log-* | while read log; do
        echo '<tr>'
        time=$(basename $log | cut -c5- | sed -r 's/^([0-9]{4})([0-9]{2})([0-9]{2})-([0-9]{2})([0-9]{2})([0-9]{2})$/\1-\2-\3 \4:\5:\6/')
        buildlog=log/build-$(basename $log)
        gitlog=log/git-$(basename $log)
        pkg=release/mixup$(basename $log | cut -c4-).tgz
        if $(status $log); then
            echo '<td><img src="ci/ok.png"></td>'
        else
            echo '<td><img src="ci/ko.png"></td>'
        fi
        echo '<td>'"$time"'</td>'
        echo '<td>&nbsp;|&nbsp;</td>'
        if [ -e $OUTDIR/$gitlog ]; then
            echo '<td><a href="'$gitlog'">git log</a></td>'
        else
            echo '<td><i>(git log not available)</i></td>'
        fi
        echo '<td>&nbsp;|&nbsp;</td>'
        echo '<td><a href="'$(basename $log)'">test log</a></td>'
        echo '<td>&nbsp;|&nbsp;</td>'
        if [ -e $OUTDIR/$buildlog ]; then
            echo '<td><a href="'$buildlog'">release build log</a></td>'
        else
            echo '<td><i>(release build log not available)</i></td>'
        fi
        echo '<td>&nbsp;|&nbsp;</td>'
        if [ -e $OUTDIR/$pkg ]; then
            echo '<td><a href="'$pkg'">download release</a></td>'
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
    git clean -d -f -q -x

    lockfile-create --use-pid --lock-name $OUTDIR/ci.lock
    lockfile-touch --lock-name $OUTDIR/ci.lock &
    BADGER="$!"

    test -d $OUTDIR/ci && rm -rf $OUTDIR/ci
    cp -R $(pwd)/src/test/ci $OUTDIR/ci
    build_site true > $OUTDIR/ci.html

    test -d $OUTDIR/log || mkdir $OUTDIR/lig
    test -d $OUTDIR/release || mkdir $OUTDIR/release

    export CI_CLEAN=clean
    log=$($(pwd)/src/test/eiffel/ci)
    cp $log $OUTDIR/log/
    buildlog=$OUTDIR/log/build-$(basename $log)
    gitlog=$OUTDIR/log/git-$(basename $log)

    git log > $gitlog

    if $(pwd)/release/build.sh -clean > $buildlog; then
        pkg=$(grep Done: $buildlog | awk '{print $5}')
        cp $pkg $OUTDIR/release/mixup$(basename $log | cut -c4-).tgz
    else
        echo 'Build failed' >> $OUTDIR/$(basename $log)
    fi
    build_site false > $OUTDIR/ci.html

    kill "$BADGER"
    lockfile-remove --lock-name $OUTDIR/ci.lock
}

lockfile-check --use-pid --lock-name $OUTDIR/ci.lock && exit 0

if git pull | grep -q 'up-to-date'; then
    case x$1 in
        x-force)
            do_ci
            ;;
        *)
            if [ -e ./force-ci ]; then
                rm -f ./force-ci
                do_ci
            fi
            ;;
    esac
else
    exec ./run-ci.sh -force # should ensure that this script is correctly taken into account when modified
fi

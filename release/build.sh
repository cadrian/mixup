#!/bin/bash

usage() {
    echo
    echo "Usage: $0 [options...]"
    echo
    echo "The options are:"
    echo
    echo "-clean              to call smarteiffel's clean (ensures a fresh build)"
    echo
    echo "-version <version>  to name the archive with a specific version number"
    echo "                    (instead of a date tag)"
    echo "                    This also forces -clean, and sets the default prefix"
    echo "                    to /usr instead of /usr/local"
    echo
    echo "-install            installs a local version in $HOME/.mixup"
    echo
    echo "-test               compiles a test release (with assertions) instead of"
    echo "                    an optimized release"
    echo
    echo "-ci                 compiles a test release (with assertions, but no sedb)"
    echo "                    for Continuous Integration."
    echo "                    Also reduces the output to only the generated package"
    echo "                    file name."
    echo
    echo "-prefix <prefix>    sets the package prefix (default is /usr/local)"
    echo
    echo "-help               this help (does not run any build)"
    echo
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# log.rc file

log_rc_release() {
    cat <<EOF
log configuration

root IN_FILE

output
        mixup_log is file "mixup.log"
                rotated each day keeping 3
                end

        mixup_con is console
                format "**** @C: @m%N"
                end

logger
        ON_CONSOLE is
                output mixup_con
                level warning
                end

        IN_FILE is
                like ON_CONSOLE with
                output mixup_log
                level info
                end

end

EOF
}

log_rc_test() {
    cat <<EOF
log configuration

root IN_FILE

output
        mixup_log is file "mixup.log"
                rotated each day keeping 3
                end

        mixup_con is console
                format "**** @C: @m%N"
                end

logger
        ON_CONSOLE is
                output mixup_con
                level warning
                end

        IN_FILE is
                like ON_CONSOLE with
                output mixup_log
                level trace
                end

end

EOF
}

log_rc_ci() {
    cat <<EOF
log configuration

root ON_CONSOLE

output
        mixup_con is console
                format "**** @C: @m%N"
                end

logger
        ON_CONSOLE is
                output mixup_con
                level trace
                end

end

EOF
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ace file

ace_release() {
    cat <<EOF
system "mixup"

root
    MIXUP: make

default
    assertion(boost)
    debug(no)
    trace(no)
    no_style_warning(no)
    no_warning(no)
    verbose(yes)
    manifest_string_trace(no)
    high_memory_compiler(yes)
    profile(no)
    relax(yes)

cluster
    liberty: "\${path_liberty}/src/loadpath.se"
    main: "${INSTALL_DIR}/src/main/eiffel/loadpath.se"

generate
    no_strip(no)
    clean(no)
    c_compiler_options: "-g -pipe -Os"
    split("legacy")

end

EOF
}

ace_test() {
    cat <<EOF
system "mixup"

root
    MIXUP: make

default
    assertion(require)
    assertion_flat_check(yes)
    debug(no)
    trace(yes)
    no_style_warning(no)
    no_warning(no)
    verbose(no)
    manifest_string_trace(no)
    high_memory_compiler(yes)
    profile(no)
    relax(yes)

cluster
    liberty: "\${path_liberty}/src/loadpath.se"
        option
            debug(yes): ABSTRACT_STRING, FIXED_STRING, NATIVELY_STORED_STRING, STRING
            --debug("parse"): DESCENDING_PARSER, PARSE_TERMINAL, PARSE_NT_NODE, PARSE_NON_TERMINAL
            --debug("parse/eiffel/build"): EIFFEL_GRAMMAR
            assertion(no): DESCENDING_PARSER, PARSE_TERMINAL, PARSE_NT_NODE, PARSE_NON_TERMINAL, EIFFEL_GRAMMAR, LOGGER, LOGGING, LOG_INTERNAL_CONF
        end

    main: "${INSTALL_DIR}/src/main/eiffel/loadpath.se"
        default
            assertion(all)
            debug(yes)
        option
            assertion(no): MIXUP_GRAMMAR
            debug(no): MIXUP_GRAMMAR, MIXUP_PARSER
        end

generate
    no_strip(yes)
    clean(no)
    c_compiler_options: "-g -pipe -O1"
    split("by_type")

end

EOF
}

ace_ci() {
    cat <<EOF
system "mixup"

root
    MIXUP: make

default
    assertion(all)
    assertion_flat_check(yes)
    debug(no)
    trace(no)
    no_style_warning(no)
    no_warning(no)
    verbose(no)
    manifest_string_trace(no)
    high_memory_compiler(yes)
    profile(no)
    relax(yes)

cluster
    liberty: "\${path_liberty}/src/loadpath.se"
        option
            assertion(require): COLLECTION_SORTER -- because there is a bug in the `slice_copy' build-in
            debug(yes): ABSTRACT_STRING, FIXED_STRING, NATIVELY_STORED_STRING, STRING
            debug("parse"): DESCENDING_PARSER, PARSE_TERMINAL, PARSE_NT_NODE, PARSE_NON_TERMINAL
            debug("parse/eiffel/build"): EIFFEL_GRAMMAR
        end

    main: "${INSTALL_DIR}/src/main/eiffel/loadpath.se"
        default
            debug(yes)
        end

generate
    no_strip(yes)
    clean(no)
    c_compiler_options: "-g -pipe"
    split("legacy")

end

EOF
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

install() {
    PKG_BIN=$1
    PKG_SHARED=$2
    LOG_LEVEL=$3

    mkdir -p ${PKG_BIN}
    find . -name 'mixup*' -type f -executable -exec cp -a {} ${PKG_BIN}/ \;

    mkdir -p ${PKG_SHARED}/modules
    cp -a $INSTALL_DIR/src/mixup/* ${PKG_SHARED}/modules/

    log_rc_${LOG_LEVEL} > ${PKG_SHARED}/log.rc
}

noecho() {
    :
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export PREFIX
export LEVEL=release
export ECHO=echo

cd $(dirname $0)
RELEASE_DIR=$(pwd)

PACKAGE_DIR=${RELEASE_DIR}/mixup-$(date +'%Y%m%d-%H%M%S')

cd ..
INSTALL_DIR=$(pwd)

BUILD_DIR=${INSTALL_DIR}/target
test -d ${BUILD_DIR} || mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

MUST_CLEAN=false
MUST_INSTALL=false
PACKAGE_ARCHIVE=${PACKAGE_DIR}.tgz
while [ $# -gt 0 ]; do
    case $1 in
        -clean)
            MUST_CLEAN=true
            ;;
        -version)
            shift
            PACKAGE_ARCHIVE=${RELEASE_DIR}/mixup-$1.tgz
            if [ -f ${PACKAGE_ARCHIVE} ]; then
                echo "**** WARNING: this version already exists."
                echo "     Press Return to continue, or ^C to abort."
                read
            fi
            MUST_CLEAN=true
            LEVEL=release
            PREFIX=${PREFIX:-/usr}
            ;;
        -h*)
            usage
            exit 0
            ;;
        -install)
            MUST_INSTALL=true
            ;;
        -test)
            BUILD_DIR=${BUILD_DIR}/test
            test -d ${BUILD_DIR} || mkdir ${BUILD_DIR}
            cd ${BUILD_DIR}
            LEVEL=test
            ;;
        -ci)
            BUILD_DIR=${BUILD_DIR}/ci
            test -d ${BUILD_DIR} || mkdir ${BUILD_DIR}
            cd ${BUILD_DIR}
            LEVEL=ci
            ECHO=noecho
            ;;
        -prefix)
            shift
            PREFIX="$1"
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done
PREFIX=${PREFIX:-/usr/local}

ace_${LEVEL} > mixup.ace

if ${MUST_CLEAN}; then
    $ECHO '~~~~ Cleaning'
    se clean mixup.ace
fi

$ECHO '~~~~ Building'
se c mixup.ace || exit 1

$ECHO '~~~~ Releasing'
test -d ${PACKAGE_DIR} && rm -rf ${PACKAGE_DIR}
PKG_BIN=${PACKAGE_DIR}/${PREFIX}/bin
PKG_SHARED=${PACKAGE_DIR}/${PREFIX}/share/mixup
install ${PKG_BIN} ${PKG_SHARED} ${LEVEL}

cat > ${PKG_SHARED}/load_paths <<EOF
${PREFIX}/share/mixup/modules
EOF

PKG_SRC=${PACKAGE_DIR}/${PREFIX}/src/mixup
mkdir -p $PKG_SRC
find . -name 'mixup*.[ch]' -type f -exec cp -a {} ${PKG_SRC}/ \;

if $MUST_INSTALL; then
    $ECHO '~~~~ Installing'
    test -d ${HOME}/.mixup || mkdir ${HOME}/.mixup
    test -d ${HOME}/.mixup/modules && rm -rf ${HOME}/.mixup/modules
    install ${HOME}/.mixup ${HOME}/.mixup

    cat > ${HOME}/.mixup/load_paths <<EOF
${HOME}/.mixup/modules
EOF
fi

$ECHO '~~~~ Packaging'
cd ${PACKAGE_DIR}
tar cfz ${PACKAGE_ARCHIVE} *
rm -rf ${PACKAGE_DIR}

$ECHO -n '~~~~ Done: package is'
echo ${PACKAGE_ARCHIVE}

$ECHO

#!/bin/bash

usage() {
    echo
    echo "Usage: $0 [-clean] [-version <version>] [-install]"
    echo
    echo "-clean    to call smarteiffel's clean (ensures a fresh build)"
    echo "-version  to name the archive with a specific version number"
    echo "          (instead of a date tag)"
    echo "-install  installs a local version in $HOME/.mixup"
    echo
}

install() {
    PKG_BIN=$1
    PKG_SHARED=$2

    mkdir -p ${PKG_BIN}
    find . -name 'mixup*' -type f -executable -exec cp {} ${PKG_BIN}/ \;

    mkdir -p ${PKG_SHARED}/modules
    cp $INSTALL_DIR/src/mixup/* ${PKG_SHARED}/modules/

    cat > ${PKG_SHARED}/log.rc <<EOF
log configuration

root IN_FILE

output
        mixup_log is file "mixup.log"
                rotated each day keeping 3
                end

logger
        ON_CONSOLE is
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

export PREFIX=${PREFIX:-/usr/local}

cd $(dirname $0)
RELEASE_DIR=$(pwd)

PACKAGE_DIR=${RELEASE_DIR}/mixup-$(date +'%Y%m%d-%H%M%S')

cd ..
INSTALL_DIR=$(pwd)

BUILD_DIR=${INSTALL_DIR}/target
test -d ${BUILD_DIR} || mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

cat > mixup.ace <<EOF
system "mixup"

root
    MIXUP: make

default
    assertion(boost)
    debug(no)
    trace(no)
    no_style_warning (no)
    no_warning(no)
    verbose(no)
    manifest_string_trace(no)
    high_memory_compiler(yes)
    profile(no)
    relax(yes)

cluster
    liberty: "\${path_liberty}/src/loadpath.se"
    main: "${INSTALL_DIR}/src/main/eiffel/loadpath.se"

generate
    no_strip(yes)
    clean(no)
    c_compiler_options: "-g -pipe -Os"
    split("by_type")

end

EOF

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
            ;;
        -h*)
            usage
            exit 0
            ;;
        -install)
            MUST_INSTALL=true
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

if ${MUST_CLEAN}; then
    echo '~~~~ Cleaning'
    se clean mixup.ace
fi

echo '~~~~ Building'
se c mixup.ace || exit 1

echo '~~~~ Releasing'
test -d ${PACKAGE_DIR} && rm -rf ${PACKAGE_DIR}
PKG_BIN=${PACKAGE_DIR}/${PREFIX}/bin
PKG_SHARED=${PACKAGE_DIR}/${PREFIX}/share/mixup
install ${PKG_BIN} ${PKG_SHARED}

cat > ${PKG_SHARED}/load_paths <<EOF
${PREFIX}/share/mixup/modules
EOF

if $MUST_INSTALL; then
    echo '~~~~ Installing'
    test -d ${HOME}/.mixup || mkdir ${HOME}/.mixup
    test -d ${HOME}/.mixup/modules && rm -rf ${HOME}/.mixup/modules
    install ${HOME}/.mixup ${HOME}/.mixup

    cat > ${HOME}/.mixup/load_paths <<EOF
${HOME}/.mixup/modules
EOF
fi

echo '~~~~ Packaging'
cd ${PACKAGE_DIR}
tar cfz ${PACKAGE_ARCHIVE} *
rm -rf ${PACKAGE_DIR}

echo '~~~~ Done: package is' ${PACKAGE_ARCHIVE}

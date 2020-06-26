#!/bin/bash
set -ex

SCRIPT_DIR=$(cd $(dirname "$0") && pwd -P)
WPT_ROOT=$SCRIPT_DIR/../..

# Approximately two months.
CHECKEND_SECONDS=5184000

update_wpt_certs() {
    WILL_EXPIRE=0
    if ! openssl x509 -checkend $CHECKEND_SECONDS -noout -in tools/certs/cacert.pem
    then
        WILL_EXPIRE=1
    elif ! openssl x509 -checkend $CHECKEND_SECONDS -noout -in tools/certs/web-platform.test.pem
    then
        WILL_EXPIRE=1
    fi

    if [[ $WILL_EXPIRE -eq 1 ]]
    then
        echo "Re-generating WPT certificates"
        ./wpt serve --config tools/certs/config.json &
        PID=$!

        echo "Waiting for wpt serve to regenerate the certificates"
        sleep 20
        kill -9 "$PID" || true

        git commit -a \
            -m "Update WPT certificates" \
            -m "Automatically updated via './wpt serve --config tools/certs/config.json'"
    fi

}

update_signed_exchange_certs () {
    # We unconditionally re-generate the SignedExchange certificates as they
    # run out after one week.
    cd ./signed-exchange/resources
    go get -u github.com/WICG/webpackage/go/signedexchange/cmd/...
    ./generate-test-sxgs.sh || true
    cd $WPT_ROOT

    git commit -a \
        -m "Update SignedExchange certificates" \
        -m "Automatically updated via './generate-test-sxgs.sh'"
}

cd $WPT_ROOT

update_wpt_certs
update_signed_exchange_certs

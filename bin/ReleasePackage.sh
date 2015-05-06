#!/bin/bash

set -e

function pkg {
        PKGNAME=$(pkgver $1)
        ln -s $1 $PKGNAME
        tar -czhvf ../$PKGNAME.tar.gz $PKGNAME
        echo "Now run: pkgup $PKGNAME.tar.gz"
        pkgup ../$PKGNAME.tar.gz
	echo "Remove the tar.gz"
        rm ../$PKGNAME.tar.gz
	echo "Remove the link"
        rm $PKGNAME
	echo "Package released: $PKGNAME"
	git tag $PKGNAME
	echo "git's tag done"
	git push --tags
	echo "Pushed on git"
	git status
}


function pkgup {
        curl -f --upload-file $1 http://config.snc1/package/
}

function gendate {
        date +%Y.%m.%d_%H.%M
}

function pkgver {
        echo "$1-$(gendate)"
}

pkg $1

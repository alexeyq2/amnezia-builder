.PHONY: builder build builder-shell

build:
	docker stop amnezia
	docker start amnezia
	docker exec --workdir /amnezia-client amnezia deploy/build_linux.sh
	docker stop amnezia

builder:
	docker container stop amnezia || true
	docker container rm amnezia || true
	docker build -t amnezia-builder:1 .
	docker container create \
		--name amnezia \
		-ti \
		-v ./:/host \
		-v ./../amnezia-client:/amnezia-client \
		amnezia-builder:1 \
		bash

builder-shell:
	docker start --attach --interactive amnezia

QT_VERSION=6.5.1
QIF_VERSION=4.6
QT_ARCH=clang_64
QT_DIR=/opt/qt
QT_BIN_DIR=${QT_DIR}/${QT_VERSION}/${QT_ARCH}/bin
QIF_DIR=/opt/qif
QIF_BIN_DIR=${QIF_DIR}/Tools/QtInstallerFramework/${QIF_VERSION}/bin

prepare-mac:
	pip3 install aqtinstall
	aqt install-qt --outputdir ${QT_DIR} mac desktop ${QT_VERSION} ${QT_ARCH} --modules \
    	qtremoteobjects \
  		qt5compat \
  	    qtshadertools
	aqt install-tool --outputdir ${QIF_DIR} mac desktop tools_ifw

build-mac:
	cd /Users/macbook/amnezia-git/amnezia-client && \
	    deploy/build_macos.sh

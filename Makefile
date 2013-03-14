PKG_NAME=docker-dev
PKG_ARCH=amd64
PKG_VERSION=1
ROOT_PATH:=$(PWD)
BUILD_PATH=build	# Do not change, decided by dpkg-buildpackage
BUILD_SRC=build_src
GITHUB_PATH=src/github.com/dotcloud/docker
INSDIR=usr/bin
SOURCE_PACKAGE=$(PKG_NAME)_$(PKG_VERSION).orig.tar.gz 
DEB_PACKAGE=$(PKG_NAME)_$(PKG_VERSION)_$(PKG_ARCH).deb

TMPDIR=$(shell mktemp -d -t XXXXXX)

# Build a debian source package
all: build_in_deb

build_in_deb:
	echo "GOPATH = " $(ROOT_PATH)
	mkdir bin
	cd $(GITHUB_PATH)/docker; GOPATH=$(ROOT_PATH) go build -o $(ROOT_PATH)/bin/docker

# DESTDIR provided by Debian packaging
install:
	# Call this from a go environment (as packaged for deb source package)
	mkdir -p $(DESTDIR)/$(INSDIR)
	mkdir -p $(DESTDIR)/etc/init
	install -m 0755 bin/docker $(DESTDIR)/$(INSDIR)
	install -o root -m 0755 etc/docker-dev.upstart $(DESTDIR)/etc/init/docker-dev.conf

$(BUILD_SRC): cleanup
	# Copy ourselves into $BUILD_SRC to comply with unusual golang constraints
	tar --exclude=*.tar.gz --exclude=checkout.tgz -f checkout.tgz -cz *
	mkdir -p $(BUILD_SRC)/$(GITHUB_PATH)
	tar -f checkout.tgz -C $(BUILD_SRC)/$(GITHUB_PATH) -xz
	cd $(BUILD_SRC)/$(GITHUB_PATH)/docker; GOPATH=$(ROOT_PATH)/$(BUILD_SRC) go get -d
	for d in `find $(BUILD_SRC) -name '.git*'`; do rm -rf $$d; done
	# Populate source build with debian stuff
	cp -R -L ./deb/* $(BUILD_SRC)

$(SOURCE_PACKAGE): $(BUILD_SRC)
	rm -f $(SOURCE_PACKAGE)
	# Create the debian source package
	tar -f $(SOURCE_PACKAGE) -C ${ROOT_PATH}/${BUILD_SRC} -cz .

# Build deb package fetching go dependencies and cleaning up git repositories
deb: $(DEB_PACKAGE)
	
$(DEB_PACKAGE): $(SOURCE_PACKAGE)
	# dpkg-buildpackage looks for source package tarball in ../
	cd $(BUILD_SRC); dpkg-buildpackage
	rm -rf $(BUILD_PATH) debian/$(PKG_NAME)* debian/files

debsrc: $(SOURCE_PACKAGE)

cleanup:
	rm -rf $(BUILD_PATH) debian/$(PKG_NAME)* debian/files $(BUILD_SRC) checkout.tgz

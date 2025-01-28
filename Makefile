VERSION:=$(shell git describe --tags --dirty --always)
COMMIT_HASH:=$(shell git rev-parse --short HEAD 2>/dev/null)
BUILD_DATE:=$(shell date "+%Y-%m-%d")
PKG:=github.com/ipfs/go-ipfs/version
LDFLAGSVERSION:=-X $(PKG).commitHash=$(COMMIT_HASH) -X $(PKG).buildDate=$(BUILD_DATE) -X $(PKG).version=$(VERSION)
# 

build:
	rm -rf ./ipfs
	(cd go-ipfs/cmd/ipfs && go build -ldflags "$(LDFLAGSVERSION)" .)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs 
build_current:
	rm -rf ./ipfs
	(cd go-ipfs/cmd/ipfs && CGO_ENABLED=1 go build -ldflags "$(LDFLAGSVERSION)" .)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs 

build_release:
	rm -rf ./ipfs
	(cd go-ipfs/cmd/ipfs && go build -trimpath -ldflags "-s -w $(LDFLAGSVERSION)" .)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs 

build_mac:
	rm -rf ./ipfs
	go version
	(cd go-ipfs/cmd/ipfs && go build -trimpath -ldflags '-s -w $(LDFLAGSVERSION) -extldflags "-sectcreate __TEXT __info_plist ../../../Info.plist"' -o ./ipfs)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs
build_linux:
	rm -rf ./ipfs
	go version
	(cd go-ipfs/cmd/ipfs && go build -trimpath -ldflags "-s -w $(LDFLAGSVERSION)" -o ./ipfs)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs
build_windows:
	rm -rf ./ipfs.exe
	go version
	(cd go-ipfs/cmd/ipfs && go build -trimpath -ldflags "-s -w $(LDFLAGSVERSION) -H=windowsgui" -o ./ipfs.exe)
	mv ./go-ipfs/cmd/ipfs/ipfs.exe ipfs.exe

run-daemon:
	./ipfs daemon
clean:
	rm -rf ./.devcontainer/docker/dirauthority/common 
tor_up: clean
	cd ./.devcontainer && docker-compose -f docker-compose.tor.yml up
tor_up_dirauth: clean
	cd ./.devcontainer && docker-compose -f docker-compose.tor.yml up dirauth1 dirauth2 
tor_down:
	cd ./.devcontainer && docker-compose -f docker-compose.tor.yml down

dummy_files:
	sh ./.devcontainer/docker/dirauthority/script/dummy_files.sh
rebuild_image:
	cd ./.devcontainer && docker build -t tor1 -f Tor.Dockerfile ./docker/dirauthority/

init:
	cd docker && make init

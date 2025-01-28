
PKG:=github.com/ipfs/go-ipfs/version
LDFLAGSVERSION:=-X $(PKG).commitHash=$(COMMIT_HASH) -X $(PKG).buildDate=$(BUILD_DATE) -X $(PKG).version=$(VERSION)
# 

build:
	rm -rf ./ipfs
	(cd go-ipfs/cmd/ipfs && go build .)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs 
build_linux:
	rm -rf ./ipfs
	(cd go-ipfs/cmd/ipfs && CGO_ENABLED=1 go build -ldflags "$(LDFLAGSVERSION)" .)
	mv ./go-ipfs/cmd/ipfs/ipfs ipfs 
run-daemon:
	./go-ipfs/cmd/ipfs/ipfs daemon
init:
	./ipfs init --bootStrap=/onion3/aec7fj7zj7dax3lzsv73mhlvplikjlauhtm6bk5dkupnkfq5csqvyjid:4001/p2p/12D3KooWQdJBVG7FZFYY5okznqYvApYCSCLxrkBLNHysTAde83UY --torPath=/Users/tumarsal/Documents/PaidPiper2020/tools/tor/tor --torConfigPath=/Users/tumarsal/Documents/PaidPiper2020/tools/tor/torrc
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
	
VERSION:=$(shell git describe --tags --dirty --always)
image: 
	docker build -f Dockerfile -t ipfs -t torplusserviceregistry.azurecr.io/private/ipfs:$(VERSION) \
									   -t torplusserviceregistry.azurecr.io/private/ipfs ../


push: 
	docker push torplusserviceregistry.azurecr.io/private/ipfs:$(VERSION) \
				torplusserviceregistry.azurecr.io/private/ipfs
image_ipfs_haproxy: 
	docker build -f All.Dockerfile -t ipfs_haproxy -t torplusserviceregistry.azurecr.io/private/ipfs_haproxy:$(VERSION) \
									   -t torplusserviceregistry.azurecr.io/private/ipfs_haproxy ../
push_ipfs_haproxy: 
	docker push torplusserviceregistry.azurecr.io/private/ipfs_haproxy:$(VERSION) \
				torplusserviceregistry.azurecr.io/private/ipfs_haproxy
fast_image:
	cd ../ && make build_linux
	docker build -f Fast.Dockerfile -t ipfs -t torplusserviceregistry.azurecr.io/private/ipfs:$(VERSION) ../

run_it:
	docker run -it --name ipfs --rm -p 9051:9051 -p 9050:9050 -p 5001:5001 -p 8080:8080 -p 28080:28080 --entrypoint /bin/bash ipfs

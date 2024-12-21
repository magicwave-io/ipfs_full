# Introduction 
This is a build repo for torplus IPFS project, it references all the packages required to build IPFS binaries as git submodules and makes the build process easier. 

# IPFS configuration
Besides the actual submodules, this repo also includes several reference configuration files with comments and instructions for deployment

- tor configuration (torrc file)
  This file needs to be placed at torrc well-known location (differs by OS), or placed together with the tor binary and run with -f flag.
- reference client ipfs configuration (ipfs_config file)
  Goes into <user folder>/.ipfs/config file (e.g. ~/.ipfs/config on linux)

## Version update  instructions

Update IPFS version:

update_version.sh 

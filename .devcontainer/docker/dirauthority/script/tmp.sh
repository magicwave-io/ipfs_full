cd /usr/local/etc/tor/
mkdir -p ~/.tor/keys
sudo tor-gencert --create-identity-key
nano ~/.tor/keys/authority_certificate
tor --list-fingerprint
sudo  nano /usr/local/etc/tor/torrc

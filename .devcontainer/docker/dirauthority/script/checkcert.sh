#!/bin/bash
if [ -f "/root/tor/keys/authority_certificate" ]; then
    true
else
    /opt/paidpiper/script/gencert.exp
fi

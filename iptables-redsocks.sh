#!/bin/bash -x
set -e

function tunnel_up(){
    ssh -o StrictHostKeyChecking=no -v openvpnas@ec2-54-246-54-223.eu-west-1.compute.amazonaws.com -22 -D 9999 -nf "sleep 90000" &
    sudo redsocks -c ~/redsocks.conf &
    sudo iptables -t nat -N REDSOCKS
    sudo iptables -t nat -A REDSOCKS -p tcp -d 10.0.0.0/8 -j DNAT --to 127.0.0.1:12345
    sudo iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j REDSOCKS
    sudo iptables -t nat -I PREROUTING 1 -d 10.0.0.0/8 -j REDSOCKS
}

if [ $1 == "start" ]; then
    tunnel_up
fi

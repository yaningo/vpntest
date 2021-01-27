#!/bin/bash
# Create new chain
sudo iptables -t nat -N REDSOCKS

# Ignore LANs and some other reserved addresses.
sudo iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN

# Put your ssh server IP here
sudo iptables -t nat -A REDSOCKS -d 54.246.54.223/4 -j RETURN

# Anything else should be redirected to port 31338
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 31338

# Any tcp connection made by `user' should be redirected, put your username here.
sudo iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner user -j REDSOCKS

./redsocks -c redsocks.conf

ssh -fND localhost:31337 user@server 2>/dev/null 1>2

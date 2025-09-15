#!/bin/bash

sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lr-add transit-router

# Create external network in IC
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 ls-add external-network-ic
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-add external-network-ic external-port-ic
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-type external-port-ic localnet
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-options external-port-ic network_name=provider

# Connect transit router to external network
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lrp-add transit-router transit-router-external 02:ac:10:ff:00:01 192.168.100.1/24
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-add external-network-ic external-ic-router
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-type external-ic-router router
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-options external-ic-router router-port=transit-router-external

# Connect transit router to transit switch
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 ts-add transit-switch
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lrp-add transit-router transit-router-switch 02:ac:10:ff:00:02 10.0.0.1/24
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-add transit-switch transit-switch-router
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-type transit-switch-router router
sudo ovn-ic-nbctl --db=tcp:127.0.0.1:6645 lsp-set-options transit-switch-router router-port=transit-router-switch

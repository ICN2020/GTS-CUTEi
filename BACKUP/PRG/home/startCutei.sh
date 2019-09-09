#!/bin/bash
ip link add gVeth0 type veth peer name gVeth1
ip link add gVeth1 type veth peer name gVeth0
ovs-vsctl add-port virbr10 gVeth1
brctl addif br0 gVeth0
ip link set gVeth1 up
ip link set gVeth0 up
ip link add eGretap type gretap local 172.16.0.19 remote 172.16.0.1
ovs-vsctl add-port virbr10 eGretap
ip link set eGretap up


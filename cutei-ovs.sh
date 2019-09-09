# create virtual link with br0 (public) to connect OVS geant switch
ip link add gVeth0 type veth peer name gVeth1
ip link add gVeth1 type veth peer name gVeth0
brctl addif br1 gVeth0
ovs-vsctl add-port geant gVeth1 -- set interface gVeth1 ofport_request=1
ip link set gVeth1 up
ip link set gVeth0 up
# Create vxlan tunnels towards GTS VM
#ovs-vsctl add-port geant vxlanMIL -- set interface vxlanMIL type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.30 ofport_request=10

#ovs-vsctl add-port geant vxlanPRG -- set interface vxlanPRG type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.31 ofport_request=20

#ovs-vsctl add-port geant vxlanHAM -- set interface vxlanHAM type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.27 ofport_request=30

#ovs-vsctl add-port geant vxlanBRA -- set interface vxlanBRA type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.28 ofport_request=40
# setup OF rules
ovs-ofctl del-flows geant
#MIL
ovs-ofctl add-flow geant priority=11,arp,nw_dst=160.80.221.99/32,action=output:10
ovs-ofctl add-flow geant priority=11,arp,nw_src=160.80.221.99/32,action=output:1
ovs-ofctl add-flow geant priority=11,ip,nw_dst=160.80.221.99/32,action=output:10
ovs-ofctl add-flow geant priority=11,ip,nw_src=160.80.221.99/32,action=output:1
#PRG
ovs-ofctl add-flow geant priority=11,arp,nw_dst=160.80.221.100/32,action=output:20
ovs-ofctl add-flow geant priority=11,arp,nw_src=160.80.221.100/32,action=output:1
ovs-ofctl add-flow geant priority=11,ip,nw_dst=160.80.221.100/32,action=output:20
ovs-ofctl add-flow geant priority=11,ip,nw_src=160.80.221.100/32,action=output:1
#HAM
ovs-ofctl add-flow geant priority=11,arp,nw_dst=160.80.221.101/32,action=output:30
ovs-ofctl add-flow geant priority=11,arp,nw_src=160.80.221.101/32,action=output:1
ovs-ofctl add-flow geant priority=11,ip,nw_dst=160.80.221.101/32,action=output:30
ovs-ofctl add-flow geant priority=11,ip,nw_src=160.80.221.101/32,action=output:1

#BRA
ovs-ofctl add-flow geant priority=11,arp,nw_dst=160.80.221.102/32,action=output:40
ovs-ofctl add-flow geant priority=11,arp,nw_src=160.80.221.102/32,action=output:1
ovs-ofctl add-flow geant priority=11,ip,nw_dst=160.80.221.102/32,action=output:40
ovs-ofctl add-flow geant priority=11,ip,nw_src=160.80.221.102/32,action=output:1


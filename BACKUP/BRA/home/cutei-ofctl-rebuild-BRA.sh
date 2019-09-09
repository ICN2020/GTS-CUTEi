ovs-ofctl del-flows virbr10
vport_cutei=$(ovs-vsctl get Interface vnet0 ofport)
vport_PRG=$(ovs-vsctl get Interface eth5 ofport)
vport_HAM=$(ovs-vsctl get Interface eth1 ofport)
vport_MIL=$(ovs-vsctl get Interface eth4 ofport)
vport_GW=$(ovs-vsctl get Interface vxlanGW ofport)

ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.221.102,actions=output:$vport_cutei
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.221.102,actions=output:$vport_cutei
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.221.100,actions=output:$vport_PRG
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.221.100,actions=output:$vport_PRG
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.221.101,actions=output:$vport_HAM
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.221.101,actions=output:$vport_HAM
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.221.99,actions=output:$vport_MIL
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.221.99,actions=output:$vport_MIL
ovs-ofctl add-flow virbr10 priority=1,actions=output:$vport_GW

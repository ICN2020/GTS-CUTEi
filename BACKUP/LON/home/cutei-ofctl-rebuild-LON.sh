ovs-ofctl del-flows virbr10
vport_cutei=$(ovs-vsctl get Interface vnet0 ofport)
#vport_PRG=$(ovs-vsctl get Interface eth3 ofport)
#vport_HAM=$(ovs-vsctl get Interface eth5 ofport)
#vport_BRA=$(ovs-vsctl get Interface eth4 ofport)
#vport_MIL=$(ovs-vsctl get Interface eth2 ofport)
vport_GW=$(ovs-vsctl get Interface vxlanGW ofport)
                                                                                                                                                                                             
#ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=40.114.206.153,actions=output:$vport_cutei                                                                                                 
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=40.114.206.153,actions=output:$vport_cutei                                                                                                  
#ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.218,actions=output:$vport_PRG                                                                                                   
#ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.218,actions=output:$vport_PRG                                                                                                    
#ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.216,actions=output:$vport_HAM                                                                                                   
#ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.216,actions=output:$vport_HAM                                                                                                    
#ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.217,actions=output:$vport_BRA
#ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.217,actions=output:$vport_BRA
#ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.219,actions=output:$vport_MIL
#ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.219,actions=output:$vport_MIL
ovs-ofctl add-flow virbr10 priority=1,actions=output:$vport_GW


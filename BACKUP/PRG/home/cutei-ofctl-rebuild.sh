ovs-ofctl del-flows virbr10
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.219,actions=output:4
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.219,actions=output:4
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.216,actions=output:8
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.216,actions=output:8
ovs-ofctl add-flow virbr10 priority=1,actions=output:6


# CUTEi over GTS
CUTEi over GTS (Geant Testbed Service)
GTS node setup
## Install kvm etc
```
sudo apt-get install qemu-kvm libvirt-bin virtinst openvswitch-switch
sudo usermod -a -G kvm gts
```
## Logout and login to apply usermod changes
## Create and start virtual network ovsnet
**save the following lines as ovsnet.xml**
```
<network>
  <name>ovs-net</name>
  <forward mode='bridge'/>
  <bridge name='virbr10'/>
  <virtualport type='openvswitch'/>
</network>
```
```
virsh net-define ovsnet.xml
virsh net-start ovs-net
```
## Create virbr10 bridge
```sudo ovs-vsctl add-br virbr10```
## Create vm1.xml of the cutei VM (example of cuteivm-gtsMIL)
```
<domain type='kvm'>
 <name>cuteivm-gtsMIL</name>
 <memory unit='KiB'>2097152</memory>
 <currentMemory unit='KiB'>2097152</currentMemory>
 <vcpu placement='static'>1</vcpu>
 <os>
   <type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
   <boot dev='hd'/>
 </os>
 <features>
   <acpi/>
   <apic/>
   <pae/>
 </features>
 <clock offset='utc'/>
 <on_poweroff>destroy</on_poweroff>
 <on_reboot>restart</on_reboot>
 <on_crash>restart</on_crash>
 <devices>
   <emulator>/usr/bin/kvm-spice</emulator>
   <disk type='file' device='disk'>
     <driver name='qemu' type='raw'/>
     <source file='/home/gts/cuteiVM-gtsMIL/cuteivm.img'/>
     <target dev='sda' bus='ide'/>
     <address type='drive' controller='0' bus='0' target='0' unit='0'/>
   </disk>
   <disk type='file' device='disk'>
     <driver name='qemu' type='qcow2' cache='none'/>
     <source file='/home/gts/cuteiVM-gtsMIL/cuteivm.qcow2'/>
     <target dev='sdb' bus='ide'/>
     <address type='drive' controller='0' bus='0' target='0' unit='1'/>
   </disk>
   <disk type='block' device='cdrom'>
     <driver name='qemu' type='raw'/>
     <target dev='hdc' bus='ide'/>
     <readonly/>
     <address type='drive' controller='0' bus='1' target='0' unit='0'/>
   </disk>
   <controller type='usb' index='0'>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
   </controller>
   <controller type='pci' index='0' model='pci-root'/>
   <controller type='ide' index='0'>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
   </controller>
   <interface type='bridge'>
     <source bridge='virbr10'/>
     <virtualport type='openvswitch'/>
     <model type='virtio'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
   </interface>
   <serial type='pty'>
     <target port='0'/>
   </serial>
   <console type='pty'>
     <target type='serial' port='0'/>
   </console>
   <input type='mouse' bus='ps2'/>
   <input type='keyboard' bus='ps2'/>
   <graphics type='vnc' port='-1' autoport='yes'/>
   <sound model='ich6'>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
   </sound>
   <video>
     <model type='cirrus' vram='9248' heads='1'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
   </video>
   <memballoon model='virtio'>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
   </memballoon>
 </devices>
</domain>
```
## Define cutei virtual machine and edit it (change mac address and uuid)
```
virsh define vm1.xml
virsh edit vm1
```
```
<interface type='bridge'>
     <mac address='52:54:00:f4:3d:62'/>
     <source bridge='virbr10'/>
     <virtualport type='openvswitch'>
       <parameters interfaceid='7143253c-9a50-4430-a915-30f889ba3a1a'/>
     </virtualport>
     <model type='virtio'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
</interface>

<disk type='file' device='disk'>
     <driver name='qemu' type='raw'/>
     <source file='/home/gts/cuteiVM-gtsMIL/cuteivm.img'/>
     <target dev='vda' bus='virtio'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
</disk>
<disk type='file' device='disk'>
     <driver name='qemu' type='qcow2'/>
     <source file='/home/gts/cuteiVM-gtsMIL/cuteivm.qcow2'/>
     <target dev='vdb' bus='virtio'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
</disk>
```



## Create vxlan tunnel with Uniroma2 node (change the local ip)
```
sudo ovs-vsctl add-port virbr10 vxlanGW -- set interface vxlanGW type=vxlan options:local_ip=172.16.0.30 options:remote_ip=172.16.0.1 ofport_request=4
```
## Add interfaces to virbr10 bridge (example for MIL node with PRG, HAM,BRA)
```
sudo ovs-vsctl add-port virbr10 eth1
sudo ovs-vsctl add-port virbr10 eth2
sudo ovs-vsctl add-port virbr10 eth3
```
## For each other cutei/GTS nodes add related eth interface to the bridge and the rule to redirect traffic to the node (example for MIL node with GW, PRG, HAM,BRA)
```
ovs-ofctl del-flows virbr10                                                                                                                                                                                        
vport_cutei=$(ovs-vsctl get Interface vnet0 ofport)                                                                                                                                                                
vport_PRG=$(ovs-vsctl get Interface eth1 ofport)                                                                                                                                                                   
vport_HAM=$(ovs-vsctl get Interface eth3 ofport)                                                                                                                                                                   
vport_BRA=$(ovs-vsctl get Interface eth2 ofport)                                                                                                                                                                   
vport_GW=$(ovs-vsctl get Interface vxlanGW ofport)                                                                                                                                                                 
                                                                                                                                                                                                                  
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.219,actions=output:$vport_cutei                                                                                                                       
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.219,actions=output:$vport_cutei                                                                                                                        
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.218,actions=output:$vport_PRG                                                                                                                         
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.218,actions=output:$vport_PRG                                                                                                                          
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.216,actions=output:$vport_HAM                                                                                                                         
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.216,actions=output:$vport_HAM                                                                                                                          
ovs-ofctl add-flow virbr10 priority=10,arp,nw_dst=160.80.103.217,actions=output:$vport_BRA                                                                                                                         
ovs-ofctl add-flow virbr10 priority=10,ip,nw_dst=160.80.103.217,actions=output:$vport_BRA                                                                                                                          
ovs-ofctl add-flow virbr10 priority=1,actions=output:$vport_GW
```

## Mods on CUTEi VM for reducing MTU due to vxlan tunnelling
changes must be written in 
**cuteiadm@uniroma2-node01:~$ cat /opt/cutei-setup/config.json**
```
{
       "version": "1",
       "VMappliance": "true",
       "ucdevice": "sdb",
       "logsize": 0,
       "usenat": "" ,
       "severity": "0",
       "eth0MTU": "1346",
       "lxcMTU": "1322"
}
```

Then restart the service (sudo service cutei-manager restart) and reboot.

Check that changes have been applied in **/etc/network/interfaces** as follows,
otherwise change manually (**/etc/network/interfaces**, **cutei-setup.sh**, **user-create.sh**).
```
eth0 mtu 1346    
lxcbr0 mtu 1322
gre mtu 1322 
```


# GW (Uniroma2) node setup
## create virtual link with br0 (public) to connect OVS geant switch
```
ip link add gVeth0 type veth peer name gVeth1
ip link add gVeth1 type veth peer name gVeth0
brctl addif br0 gVeth0
ovs-vsctl add-port geant gVeth1 -- set interface gVeth1 ofport_request=1
ip link set gVeth1 up
ip link set gVeth0 up
# Create vxlan tunnels towards GTS VM
ovs-vsctl add-port geant vxlanMIL -- set interface vxlanMIL type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.30 ofport_request=10
ovs-vsctl add-port geant vxlanPRG -- set interface vxlanPRG type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.31 ofport_request=20
ovs-vsctl add-port geant vxlanHAM -- set interface vxlanHAM type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.27 ofport_request=30
ovs-vsctl add-port geant vxlanBRA -- set interface vxlanBRA type=vxlan options:local_ip=172.16.0.1 options:remote_ip=172.16.0.28 ofport_request=40

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
```


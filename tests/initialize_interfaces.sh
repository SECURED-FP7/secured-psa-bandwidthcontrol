#!/bin/bash
#Disabling TCP segmentation offload, generic segmentation offload and generic receiver offload
#since it can affect the MTU to surpass 1514 which maybe can cause issues in tc qdiscs.

sudo ethtool -K eth0 tso off
sudo ethtool -K eth0 gso off
sudo ethtool -K eth0 gro off
sudo ethtool --offload  eth0  rx off  tx off
sudo ethtool -K eth1 tso off
sudo ethtool -K eth1 gso off
sudo ethtool -K eth1 gro off
sudo ethtool --offload  eth1  rx off  tx off
sudo ethtool -K br0 tso off
sudo ethtool -K br0 gso off
sudo ethtool -K br0 gro off
sudo ethtool --offload  br0  rx off  tx off

#
#Changing the trasmit queue length of the interfaces since it may cause extra queueing
#which can affect the burstiness of the tbf qdisc
#
ifconfig eth0 txqueuelen 1
ifconfig eth1 txqueuelen 1
ifconfig br0 txqueuelen 1

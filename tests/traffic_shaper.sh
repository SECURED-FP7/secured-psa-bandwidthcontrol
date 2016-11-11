#!/bin/bash
#
#	Created: 19/02/2016
#	Author: Savvas Charalambides
#
#	Information: 
#	This script can be used to perform traffic shaping inside a VM that
#	is used as a gateway for user traffic. Traffic from the local LAN enters 
#	through eth0 and traffic from the Internet enters eth1. This way we can
#	use the egress queue of each interface to perform shaping both for ingress 
#	and egress traffic to and from the local LAN. We use eth0's egress queue
#	to shape downlink traffic and eth1's egress queue to shape uplink traffic.
#
#	This script uses the token buffer queue discipline to perform very
#	simple traffic shaping without using any other classful queue disciplines.
#	Thus, we do no prioritize traffic and all packets are handled uniformly.
#
#                         
#  +-----------+         +-----+       +-------+         +---------+      
#  | End User  |---------| NED |-------| PSA   |-------- | Internet|
#  +-----------+  IPSec  +-----+       +-------+         +---------+           
#                                    eth0     eth1    
# 				     tc        tc
#                   		    |  |      |  |
#                                   |  |      |  |
#				    |__|      |__|
#				   Egress     Egress
#				Token Buffer  Token Buffer 	
#
#
#	In order to shape the downlink rate
#	---------------------------------------------------------------------
#	This script attaches a token buffer queue discipline to the root of 
#	the devices. Linux tc uses the following notation for rates:
#		rate:
#			kbps -> KB/s
#			mbps -> MB/s
#			kbit -> Kb/s
#			mbit -> Mb/s
#	
#		latency: in ms (milliseconds), the time a packet can wait in queue 
#               Suggested values:
#			For rate <=2MB/s -> latency: 25ms
#			For rate >2MB/s  -> latency: 30ms
#	
#		burst: in Kb, the size of the token bucket 
#		Suggested values:
#			For rate <=2MB/s -> burst: 15K
#			For rate >2MB/s  -> burst: 30K
#
#		Download and Upload limiting:
#			To limit download: apply on eth0
#			To limit upload: apply on eth1
#
#		Examples of how the final command should be for different shaping occasions: 
#			For setting the download rate limit at 100KB/s:
#			    tc qdisc add dev eth0 handle 10:0 root tbf rate 100kbps latency 25ms burst 15K
#			For setting the upload rate limit at 100KB/s:
#                           tc qdisc add dev eth1 handle 10:0 root tbf rate 100kbps latency 25ms burst 15K
#			For setting the download limit at 1.5MBs:
#                           tc qdisc add dev eth0 handle 10:0 root tbf rate 1.5mbps latency 25ms burst 15K
#			For setting the upload limit at 4MB/s:
#                           tc qdisc add dev eth1 handle 10:0 root tbf rate 4mbps latency 30ms burst 30K
########################################################################################

TC=/sbin/tc

##################################################
#START OF Variable Definition
#////////////////////////////////////////////////
################################################

#################
# Section 1.
# LAN: interface facing the client
# WAN: interface facing the internet
################
LAN=eth0
WAN=eth1

##############################################
# Section 2.
#  Setting the values for rate based on the above chart
#    LAN_R: the desired download rate
#    WAN_R: the desired upload rate
#  The default values limit the rate to:
#    Uplink:250KB/s
#    Downlink: 500KB/s
###########################
LAN_R=500kbps
WAN_R=250kbps


######
# Section 3.
# Setting the values for latency and burst.
# 
# WAN_B: burst value for wan interface (eth1)
# WAN_L: latency value for wan interface (eth1)
#
# LAN_B: burst value for lan interface (eth0)
# LAN_L: latency value for lan interface (eth0)
#
# Since the default rates are both <2MB/s the default
# values for latency and burst are the following:
# burst: 15K
# latency: 25ms
#
# If the rate will be >2MB/s then change latency and
# burst as follows:
# burst:30K
# latency: 30ms
#
#####

WAN_B=15K
WAN_L=25ms

LAN_B=15K
LAN_L=25ms

##################################################
#END OF VARIABLE DEFINTION
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
##################################################


##################################################
#START OF INTERFACE SHAPING
#/////////////////////////////////////////////
##################################################
####################################################
# Section 1.
#Clering previous configurations on the devices
####################################################
$TC qdisc del dev $LAN root
$TC qdisc del dev $WAN root


#############################################################################
# Section 2.
# Downlink shaping: 
# 1. In order to shape the download rate keep the following line uncommented
#
#############################################################################
$TC qdisc add dev $LAN handle 10:0 root tbf rate $LAN_R latency $LAN_L burst $LAN_B


##############################################################################
# Section 3.
# Uplink shaping:
# 1. In order to shape the uplink rate keep the following line uncommented
#
#
##############################################################################
$TC qdisc add dev $WAN handle 10:0 root tbf rate $WAN_R latency $WAN_L burst $WAN_B

##################################################
#END OF	INTERFACE SHAPING
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
##################################################

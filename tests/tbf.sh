#!/bin/bash
#
#	This script attaches a token buffer queue discipline to the root of 
#	the $DEV device. The script takes as input parameters the following:
#		rate:
#			kbps -> KB/s
#			mbps -> MB/s
#			kbit -> Kb/s
#			mbit -> Mb/s
#	
#		latency: in ms (milliseconds), Suggested values:
#			For rate <=2MB/s -> latency 25ms
#			For rate >2MB/s  -> latency 30ms
#	
#		burst: the size of the token bucket, Suggested values:
#			For rate <=2MB/s -> burst: 15K
#			For rate >2MB/s  -> burst: 30K
#
#		Download and Upload limiting:
#			To limit download: apply on eth0
#			Ro limit upload: apply on eth1
#
#		Examples: 
#			For setting the download rate limit at 100KB/s:
#				bash tbf.sh eth0 100kbps 15K 25ms
#			For setting the upload rate limit at 100KB/s:
#                               bash tbf.sh eth1 100kbps 15K 25ms
#			For setting the download limit at 1.5MB/s:	
#				bash tbf.sh eth0 1.5mbps 15K 25ms
#			For setting the upload limit at 4MB/s:
#				bash tbf.sh eth1 4mbps 30K 30ms

DEV=$1
R=$2
B=$3
L=$4

TC=/sbin/tc

#
#	Clering previous configurations on $DEV
#
$TC qdisc del dev $DEV root

#
#	Applying the tbf qdisc onto $DEV with required rate, burst and latency
#
$TC qdisc add dev $DEV handle 10:0 root tbf rate $R latency $L burst $B

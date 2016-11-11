#!/bin/bash
DEV=$1
TC=/sbin/tc
$TC qdisc del dev $DEV root

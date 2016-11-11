#!/bin/bash
DEV=$1
TC=/sbin/tc
$TC -s qdisc ls dev $DEV

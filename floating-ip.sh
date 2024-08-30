#!/bin/bash

sleep 30

crm configure primitive stonith-ssh stonith:external/ssh \
    params hostlist="webz-001 webz-002 webz-003" \
    pcmk_host_list="webz-001 webz-002 webz-003"

ip addr add 192.168.16.100/20 dev eth0

crm configure primitive FloatingIP ocf:heartbeat:IPaddr2 \
      params ip="192.168.16.100" cidr_netmask="20" \
      op monitor interval="30s"

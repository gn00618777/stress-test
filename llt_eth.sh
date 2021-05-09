#!/bin/bash

paket_loss_count=0
ping $1 | 
	while read -r line
	  do
		seqnum=`echo $line | awk '{print $5}' | sed 's/icmp_seq=//g'`
		if [ $((seqnum-preseq)) -ne 1 ] && [ $seqnum != "bytes" ]; then
			echo "seqnum=$seqnum preseq=$preseq"
			packet_loss_count=$((packet_loss_count+1))
			echo "packet_loss_count=$packet_loss_count"
		fi

		preseq=$seqnum
	  done

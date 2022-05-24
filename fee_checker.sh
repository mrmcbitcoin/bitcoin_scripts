#!/bin/bash

MAX_DIFF=30000
REG_FEE=1000
HIGH_FEE=10000

node_pub=$(lncli getinfo|jq -r '.identity_pubkey')

channel_count=$(lncli listchannels|grep -c chan_id)
channel_count=$((channel_count-1)) # shift to zero based counting

# check channel balance
for channel_num in $( seq 0 $channel_count );do
	local_balance=($(lncli listchannels|jq -r --arg channel_num "$channel_num" ".[] | .[$channel_num].local_balance"))
	remote_balance=($(lncli listchannels|jq -r --arg channel_num "$channel_num" ".[] | .[$channel_num].remote_balance"))
	
	chan_id=$(lncli listchannels|jq -r --arg channel_num "$channel_num" ".[] | .[$channel_num].chan_id") \
	remote_pubkey=$(lncli listchannels|jq -r --arg channel_num "$channel_num" ".[] | .[$channel_num].remote_pubkey")
	node1_chan_fee=$(lncli getchaninfo $chan_id|jq '.node1_policy.fee_base_msat')
	node2_chan_fee=$(lncli getchaninfo $chan_id|jq '.node2_policy.fee_base_msat')

	node1_pub=$(lncli getchaninfo $chan_id|jq -r '.node1_pub')
	node2_pub=$(lncli getchaninfo $chan_id|jq -r '.node2_pub')

	if [ "$node1_pub" == "$node_pub" ]
		then
			node_num=1
			chan_fee=$(lncli getchaninfo $chan_id|jq -r '.node1_policy.fee_base_msat')
	elif [ "$node2_pub" == "$node_pub" ]
		then
			node_num=2
			chan_fee=$(lncli getchaninfo $chan_id|jq -r '.node2_policy.fee_base_msat')
	fi

	# find the balance diff
	if [ $local_balance -gt $remote_balance ]
	then
		bal_diff=$(( $local_balance - $remote_balance ))
	elif [ $remote_balance -gt $local_balance ]
	then
		bal_diff=$(( $remote_balance - $local_balance ))
	fi

	# find unbalanced outs
	if [ $bal_diff -gt $MAX_DIFF ]
		then
			# check fee of unbalanced outs
			if [ $chan_fee -eq $REG_FEE ]
			then
				# Warn or offer to raise fee of unbalanced outs
				if [ $local_balance -lt $remote_balance ]
				then
				echo "You should raise the channel fee of $chan_id"
				exit 1
				fi
			else
			# test with this uncommented
			#echo "Channel fee of $chan_id with remote_bal:$remote_balance local_bal:$local_balance is already $chan_fee"

			exit 0
			fi
	fi
done


## part 2
# find all high fee channels
# Warn or offer to lower fee of balanced channels

# Todo: add an ignore channel filter

#!/bin/bash

# Name: fee_printer.sh
#
# Description:
#   Prints fee's we have set on our end and other useful information
#
# Notes: takes no args, just run it like: "bash fee_printer.sh"
#

get_chanpoint (){
	# arg1 chan_id
	chan_point="$(lncli getchaninfo $1|jq -j '.chan_point')"
	echo -n "${chan_point:0:4}..${chan_point:60:6}"
}

get_nodealias (){
	# arg1 node_pub
	node_alias=$(lncli getnodeinfo $1|jq -j '.node|.alias')
	node_alias=${node_alias//[^a-zA-Z0-9_\[\]. ]/}
	node_alias=\"$node_alias\"
	printf "%-24s" "$node_alias"
	#echo -n $node_alias
}

get_chaninfo () {
	#arg1 Name, arg2 nodeX, arg 3 sub_policy
	echo -en "\t$1:"
	nodeX_policy="node$2_policy"
	sub_policy=$3
 	lncli getchaninfo $chan_id|jq -j --arg nodeX_policy "$nodeX_policy" --arg sub_policy "$sub_policy" ".$nodeX_policy|.$sub_policy" 
	echo -en "\t"
}

get_fees ()
{
	# arg1 INT node number in channel 
	nodeX=$1
	get_chaninfo MinHTLC $nodeX min_htlc
	get_chaninfo FeeBase $nodeX fee_base_msat
	get_chaninfo FeeRate $nodeX fee_rate_milli_msat
	get_chaninfo Disabled $nodeX disabled 
}


fee_printer () {

	# arg1 is a list of channels
	node_pub=$2
	for chan_id in $1
	do
  		node1_pub=$(lncli getchaninfo $chan_id|jq -j ".node1_pub")
	
		if [ $node1_pub == $node_pub ];then
			node2_pub=$(lncli getchaninfo $chan_id|jq -j ".node2_pub")
			echo -en "$node2_pub "
			get_nodealias $node2_pub
			get_fees 1
			get_chanpoint $chan_id
			echo
	else
	       	echo -en "$node1_pub "
	        get_nodealias $node1_pub
		get_fees 2
		get_chanpoint $chan_id
		echo
	fi
	done
}

channels_by_id=$(lncli listchannels|jq -r '.channels[]|.chan_id')
node_pub=$(lncli getinfo|jq -r '.identity_pubkey')

fee_printer "$channels_by_id" $node_pub

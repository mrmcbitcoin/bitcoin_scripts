#!/bin/env python

import sys
#Usage ./short2longchan.py SHORT_CHAN_ID
def lnd_to_cl_scid(s):
    block = s >> 40
    tx = s >> 16 & 0xFFFFFF
    output = s  & 0xFFFF
    return (block, tx, output)

def cl_to_lnd_scid(s):
    s = [int(i) for i in s.split(':')]
    return (s[0] << 40) | (s[1] << 16) | s[2]

def main():
	short_chan_id = sys.argv[1]
	print(cl_to_lnd_scid(short_chan_id))

if __name__ == '__main__':
  main()

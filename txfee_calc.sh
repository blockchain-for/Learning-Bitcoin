#!/bin/bash

if [ -z $1 ];
then
    echo "You must include the raw transaction hex as an argument.";
    exit;
fi

usedtxid=($(bitcoin-cli -testnet decoderawtransaction $1 | jq -r '.vin | .[] | .txid'))
usedvout=($(bitcoin-cli -testnet decoderawtransaction $1 | jq -r '.vin | .[] | .vout'))
btcin=$(for ((i=0; i<${#usedtxid[*]}; i++)); do txid=${usedtxid[i]}; vout=${usedvout[i]}; bitcoin-cli -testnet listunspent | jq -r '.[] | select (.txid | contains("'${txid}'")) | select(.vout | contains('$vout')) | .amount'; done | awk '{s+=$1} END {print s}')
btcout=$(bitcoin-cli -testnet decoderawtransaction $1 | jq -r '.vout  [] | .value' | awk '{s+=$1} END {print s}')
btcout_f=$(awk -v btcout="$btcout" 'BEGIN { printf("%f\n", btcout) }' </dev/null)
echo "$btcin-$btcout_f"| /home/lshoo/bitcoin-26.0/bin/bitcoin-cli
#!/bin/bash

token_name='my firts NFT'
token_amount='1'
fee='0'
output='0'
ipfs_hash='QmRfENJAHPyQwrE2FxitXRxAx1eAuncX8xyT1bDjSndXmY'
LOCAL_PATH='/keys'
NETWORK='--mainnet'

function cardano_cli () {
	local CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
	local arguments=(
		"${@}"
	)
	docker run -it --entrypoint cardano-cli \
                        -e NETWORK="${NETWORK}" \
                        -e CARDANO_NODE_SOCKET_PATH="${CARDANO_NODE_SOCKET_PATH}" \
                        -v cardano-node-ipc:/ipc \
			-v "${PWD}":"${LOCAL_PATH}" \
                        inputoutput/cardano-node "${arguments[@]}"
}
function generate_payment_keys () {
	local arguments=(
		address key-gen 
		--verification-key-file "${LOCAL_PATH}/payment.vkey" 
		--signing-key-file "${LOCAL_PATH}/payment.skey"
	)
	cardano_cli "${arguments[@]}"
}
function generate_payment_address () {
	local arguments=(
		address build 
		--payment-verification-key-file "${LOCAL_PATH}/payment.vkey" 
		--out-file "${LOCAL_PATH}/payment.addr" 
		"${NETWORK}"
	)
	cardano_cli "${arguments[@]}" 	
	sudo chmod 755 'payment.addr'
	PAYMENT_ADDRESS=$(cat 'payment.addr')
}
function get_finance_status () {
	local arguments=(
		query utxo 
		--address "${PAYMENT_ADDRESS}" 
		"${NETWORK}"
	)
	cardano_cli "${arguments[@]}"
}

function main () {
	cardano_cli  'query' 'tip' '--mainnet'
	cardano_cli 'version'
	echo "generando payment keys"
	generate_payment_keys
	echo "generando payment address"
	#TODO: si la direccion existe, no crear una nueva
	generate_payment_address
	echo "dir: [${PAYMENT_ADDRESS}]"
	get_finance_status
}

echo "Mintin My NFT form Cardano CLI"
main

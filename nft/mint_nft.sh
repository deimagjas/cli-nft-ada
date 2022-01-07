#!/bin/bash

token_name='my firts NFT'
token_amount='1'
fee='0'
output='0'
ipfs_hash='QmRfENJAHPyQwrE2FxitXRxAx1eAuncX8xyT1bDjSndXmY'
CHOOSE_NETWORK=${1}
PAYMENT_ADDR_FILE='payment.addr'

function configure_network () {
	case  "${CHOOSE_NETWORK}" in 
	mainnet)
		NETWORK='mainnet'
		NETWORK_CLI=(--mainnet)
		VOLUME_IPC='cardano-node-ipc'
		LOCAL_PATH='/keys'
		;;
	testnet) 
		NETWORK='testnet'
		NETWORK_CLI=(--testnet-magic 1097911063)
		VOLUME_IPC='cardano-testnet-node-ipc'
		LOCAL_PATH='/keys'
		;;
	*)
		echo "bad option" 
		return
		;;
	esac
}
function cardano_cli () {
	local CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'
	local arguments=(
		"${@}"
	)
	docker run -it --entrypoint cardano-cli \
                        -e NETWORK="${NETWORK}" \
                        -e CARDANO_NODE_SOCKET_PATH="${CARDANO_NODE_SOCKET_PATH}" \
                        -v "${VOLUME_IPC}":/ipc \
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
		--out-file "${LOCAL_PATH}/${PAYMENT_ADDR_FILE}" 
		"${NETWORK_CLI[@]}"
	)
	cardano_cli "${arguments[@]}" 	
	sudo chmod 755 'payment.addr'
}
function show_addr () {
	PAYMENT_ADDRESS=$(cat "${PAYMENT_ADDR_FILE}" )
	echo "dir: [${PAYMENT_ADDRESS}]"
}
function get_finance_status () {
	local arguments=(
		query utxo 
		--address "${PAYMENT_ADDRESS}" 
		"${NETWORK_CLI[@]}"
	)
	cardano_cli "${arguments[@]}"
}

function main () {
	configure_network
	arguments_query=(query tip "${NETWORK_CLI[@]}")
	cardano_cli "${arguments_query[@]}"
	if [[ ! -f "${PWD}/${PAYMENT_ADDR_FILE}" ]]; then
		echo "generando payment keys"
        	generate_payment_keys
        	echo "generando payment address"
		generate_payment_address
	fi
	show_addr
	get_finance_status
}

echo "Mintin My NFT form Cardano CLI"
main

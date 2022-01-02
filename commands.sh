#!/bin/bash

echo "Iniciando servicio de Docker..."
sudo systemctl restart docker.service
echo "Iniciando nodo de Cardano..."
docker run -e NETWORK=mainnet -v cardano-node-ipc:/ipc -v cardano-node-data:/data -v  cardano-nft-keys:/keys inputoutput/cardano-node
echo "Mostrando nombre del container"
docker ps -a
echo "Exportando CARDANO_NODE_SOCKET_PATH..."
export CARDANO_NODE_SOCKET_PATH='/ipc/node.socket'

#docker exec -e CARDANO_NODE_SOCKET_PATH=/ipc/node.socket  -it relay cardano-cli query tip --mainnet


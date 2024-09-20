# RPC="https://eth-sepolia.api.onfinality.io/public" # sepolia
# RPC="https://sepolia.drpc.org" # sepolia
RPC="127.0.0.1:8545"
BASE_RPC="https://1rpc.io/base"

include .env
export

none:

layerZero-deploy:
	forge script script/LayerZero.s.sol:Deploy --broadcast --private-key $(PRIVATE_KEY) -vvvv
layerZero-setpeer:
	forge script script/LayerZero.s.sol:SetPeer --broadcast --private-key $(PRIVATE_KEY) -vvvv
layerZero-send:
	forge script script/LayerZero.s.sol:Send --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv
layerZero-verify:
	forge verify-contract \
	0xCF06f7BC9D3Cd7b068F059AB4c19f237F3A40F8C \
	src/LayerZero.sol:LayerZero \
	-e $(ETHERSCAN_API_KEY) \
	--rpc-url https://sepolia.drpc.org \
	--guess-constructor-args \
	--chain sepolia \
	--watch

test-lz-existing:
	forge test --match-test "testLayerZeroExisting" --fork-url ${RPC} -vvvv
test-lz-new:
	forge test --match-test "testLayerZeroNew" --fork-url ${RPC} -vvvv

fork:
	anvil -f wss://sepolia.drpc.org

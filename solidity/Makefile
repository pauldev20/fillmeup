# RPC="https://eth-sepolia.api.onfinality.io/public" # sepolia
# RPC="https://sepolia.drpc.org" # sepolia
RPC="127.0.0.1:8545"
BASE_RPC="https://1rpc.io/base"

include .env
export

none:

bridgeSelector-deploy-normal:
	forge script script/BridgeSelector.s.sol:DeployNormal --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv --ffi
# bridgeSelector-deploy:
# 	forge clean
# 	forge build
# 	forge script script/BridgeSelector.s.sol:DeployProxy --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv --ffi
bridgeSelector-verify:
	forge verify-contract \
	0x4CD5D8EC1e9C3909d14f378f3348F3AB0A04E172 \
	src/BridgeSelectorV1.sol:BridgeSelectorV1 \
	-e $(ETHERSCAN_API_KEY) \
	--rpc-url https://sepolia.drpc.org \
	--guess-constructor-args \
	--chain sepolia \
	--watch
bridgeSelector-send:
	forge script script/BridgeSelector.s.sol:TransferTest --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv	

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
test-selector:
	forge test --match-test "testBridgeSelector" --fork-url ${RPC} -vvvv 
test-selector-existing:
	forge test --match-test "testBridgeSelectorExisting" --fork-url ${RPC} -vvvv 

fork:
	anvil -f wss://sepolia.drpc.org

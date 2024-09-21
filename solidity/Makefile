# RPC="https://eth-sepolia.api.onfinality.io/public" # sepolia
# RPC="https://sepolia.drpc.org" # sepolia
RPC="127.0.0.1:8545"
BASE_RPC="https://1rpc.io/base"

include .env
export

none:

bridgeSelector-deploy:
	forge script script/BridgeSelector.s.sol:DeployNormal --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv --ffi
bridgeSelector-verify:
	forge verify-contract \
	0x7b2E16f2a8cAf323AD4828BA5D8F6C36a679d2e2 \
	src/BridgeSelector.sol:BridgeSelector \
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
# layerZero-send:
# 	forge script script/LayerZero.s.sol:Send --broadcast --fork-url $(RPC) --private-key $(PRIVATE_KEY) -vvvv
layerZero-verify:
	forge verify-contract \
	0x11545fE290A922c557274D4b53Ef3880175D40D8 \
	src/LayerZero.sol:LayerZero \
	-e $(ETHERSCAN_API_KEY) \
	--rpc-url https://sepolia.drpc.org \
	--guess-constructor-args \
	--chain sepolia \
	--watch

# test-lz-existing:
# 	forge test --match-test "testLayerZeroExisting" --fork-url ${RPC} -vvvv
# test-lz-new:
# 	forge test --match-test "testLayerZeroNewSingle" --fork-url ${RPC} -vvvv
test-lz-new-batch:
	forge test --match-test "testLayerZeroNewBatch" --fork-url ${RPC} -vvvv
test-selector-new:
	forge test --match-test "testBridgeSelectorNew" --fork-url ${RPC} -vvvv 
# test-selector-existing:
# 	forge test --match-test "testBridgeSelectorExisting" --fork-url ${RPC} -vvvv 

fork:
	anvil -f wss://sepolia.drpc.org

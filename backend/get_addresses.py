from web3 import Web3
import time
import json

provider_url = 'https://rpc.sepolia.org'
w3 = Web3(Web3.HTTPProvider(provider_url))

selector_address = '0x903A4726c67e5Ea06Edf29CA780c539B5137d170'
with open('selector.json', 'r') as f:
    selector_abi = f.read()

selector_contract = w3.eth.contract(address=selector_address, abi=selector_abi)
weth_address = selector_contract.functions.weth.call()

with open('weth.json', 'r') as f:
    weth_abi = f.read()
weth_contract = w3.eth.contract(address=weth_address, abi=weth_abi)

print('waiting')
time.sleep(1)

def get_approval_events():
    approval_filter = weth_contract.events.Approval.create_filter(
        from_block=6731900, 
        to_block='latest',
        argument_filters={'guy': selector_address} 
    )
    return approval_filter.get_all_entries()

approval_events = get_approval_events()
addresses = []

for event in approval_events:
    # print(event)
    owner_address = event['args']['src']
    amount_approved = event['args']['wad']
    addresses.append(owner_address)
    print(f"Address {owner_address} approved {amount_approved} tokens")


with open('addresses.json', 'w') as f:
    json.dump(addresses, f)

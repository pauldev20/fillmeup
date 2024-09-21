from web3 import Web3
import time
import json
from dotenv import load_dotenv
import os

load_dotenv()
ADDRESS = os.environ.get("ADDRESS")
PRIVATE_KEY = os.environ.get("PRIVATE_KEY")
CONTRACT = os.environ.get("CONTRACT")

with open("addresses.json", "r") as f:
    addresses = json.load(f)

PROVIDER_URL = "https://rpc.sepolia.org"
AMOUNT = int(0.0001 * 1e18)
DEST_URLS = [
    {
        "dsteid": 40245,
        "threshold": 0.001 * 1e18,
        "amount": AMOUNT,
        "rpc": "https://base-sepolia-rpc.publicnode.com",
    },
    {
        "dsteid": 40231,
        "threshold": 0.001 * 1e18,
        "amount": AMOUNT,
        "rpc": "https://arbitrum-sepolia.blockpi.network/v1/rpc/public",
    },
    {
        "dsteid": 40267,
        "threshold": 0.001 * 1e18,
        "amount": AMOUNT,
        "rpc": "https://polygon-amoy.drpc.org",
    },
    {
        "dsteid": 40232,
        "threshold": 0.001 * 1e18,
        "amount": AMOUNT,
        "rpc": "https://sepolia.optimism.io",
    },
    {
        "dsteid": 40322,
        "threshold": 0.001 * 1e18,
        "amount": AMOUNT,
        "rpc": "https://rpc-quicknode-holesky.morphl2.io",
    },
]

HYPER = {
    "dsteid": 534351,
    "threshold": 0.001 * 1e18,
    "amount": AMOUNT,
    "rpc": "https://rpc-quicknode-holesky.morphl2.io",
}

w3 = Web3(Web3.HTTPProvider(PROVIDER_URL))

selector_address = CONTRACT
with open("selector.json", "r") as f:
    selector_abi = f.read()
selector_contract = w3.eth.contract(address=selector_address, abi=selector_abi)

for a in addresses:
    refilling_chains = []
    for dest in DEST_URLS:
        continue
        w3_dest = Web3(Web3.HTTPProvider(dest["rpc"]))
        balance = w3_dest.eth.get_balance(a)
        print(f"current balance of {a}, {balance}, {dest["rpc"]}")
        if balance < dest["threshold"]:
            refilling_chains.append(dest)
    if len(refilling_chains) > 0:
        print(f"refilling for {a} on {len(refilling_chains)} chains")
        time.sleep(2)
        data = []
        cummulative_quote = 0
        for dest in refilling_chains:
            quote = selector_contract.functions.getLayerZeroQuote(
                dest["dsteid"], dest["amount"], a
            ).call()
            print("have to wait because of rate limit sorry")
            time.sleep(2)
            data.append((dest["dsteid"], dest["amount"], quote)) 
            cummulative_quote += quote
        transaction = selector_contract.functions.bridgeWithLayerZero(
            data, 
            a,
            cummulative_quote
        ).build_transaction(
            {
                "from": ADDRESS,
                "nonce": w3.eth.get_transaction_count(ADDRESS),
                'maxFeePerGas': w3.to_wei('35', 'gwei'),
            }
        )
        signed_tx = w3.eth.account.sign_transaction(transaction, PRIVATE_KEY)
        txn_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
        print("waiting for transaction to complete:", txn_hash.hex())
        txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)
    dest = HYPER
    w3_dest = Web3(Web3.HTTPProvider(dest["rpc"]))
    balance = w3_dest.eth.get_balance(a)
    print(f"current balance of {a}, {balance}, {dest["rpc"]}")
    if balance < dest["threshold"]:
        quote = selector_contract.functions.getHyperlaneQuote(
                dest["dsteid"], dest["amount"]).call()
        transaction = selector_contract.functions.bridgeWithHyperlane(
            dest["dsteid"], dest["amount"], a
        ).build_transaction(
            {
                "from": ADDRESS,
                "nonce": w3.eth.get_transaction_count(ADDRESS),
                'maxFeePerGas': w3.to_wei('35', 'gwei'),
            }
        )
        signed_tx = w3.eth.account.sign_transaction(transaction, PRIVATE_KEY)
        txn_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
        print("waiting for transaction to complete:", txn_hash.hex())
        txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)

# weth_address = selector_contract.functions.weth.call()

# with open('weth.json', 'r') as f:
#     weth_abi = f.read()
# weth_contract = w3.eth.contract(address=weth_address, abi=weth_abi)

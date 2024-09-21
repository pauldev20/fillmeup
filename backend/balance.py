from web3 import Web3
import time
import json
from dotenv import load_dotenv
import os

load_dotenv()
ADDRESS = os.environ.get("ADDRESS")
PRIVATE_KEY = os.environ.get("PRIVATE_KEY")

with open("addresses.json", "r") as f:
    addresses = json.load(f)

PROVIDER_URL = "https://rpc.sepolia.org"
DEST_URLS = [
    {
        "dsteid": 40245,
        "threshold": 0.001 * 1e18,
        "amount": 1000,
        "rpc": "https://base-sepolia-rpc.publicnode.com",
    },
]

w3 = Web3(Web3.HTTPProvider(PROVIDER_URL))

selector_address = "0x903A4726c67e5Ea06Edf29CA780c539B5137d170"
with open("selector.json", "r") as f:
    selector_abi = f.read()
selector_contract = w3.eth.contract(address=selector_address, abi=selector_abi)

for dest in DEST_URLS:
    w3_dest = Web3(Web3.HTTPProvider(dest["rpc"]))
    for a in addresses:
        balance = w3_dest.eth.get_balance(a)
        print(f"current balance of {a}, {balance / 1e18}")
        if balance < dest["threshold"]:
            print("refilling")
            quote = selector_contract.functions.getLayerZeroQuote(
                dest["dsteid"], dest["amount"], a
            ).call()
            transaction = selector_contract.functions.bridgeWithLayerZero(
                dest["dsteid"], dest["amount"], a, quote
            ).build_transaction(
                {
                    "from": ADDRESS,
                    "nonce": w3.eth.get_transaction_count(ADDRESS),
                    "gas": 360_000,
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

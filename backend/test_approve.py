from web3 import Web3
import time
import json
from dotenv import load_dotenv
import os

load_dotenv()
ADDRESS = os.environ.get("TEST_ADDRESS")
PRIVATE_KEY = os.environ.get("TEST_PRIVATE_KEY")

with open("addresses.json", "r") as f:
    addresses = json.load(f)

PROVIDER_URL = "https://rpc.sepolia.org"
w3 = Web3(Web3.HTTPProvider(PROVIDER_URL))

selector_address = "0x290e31032c33331D724298544663dB502C8cC77D"
with open("selector.json", "r") as f:
    selector_abi = f.read()
selector_contract = w3.eth.contract(address=selector_address, abi=selector_abi)

weth_address = selector_contract.functions.weth.call()

with open("weth.json", "r") as f:
    weth_abi = f.read()
weth_contract = w3.eth.contract(address=weth_address, abi=weth_abi)

def deposit(amount):
    transaction = weth_contract.functions.deposit().build_transaction(
        {
            "from": ADDRESS,
            "nonce": w3.eth.get_transaction_count(ADDRESS),
            "gas": 360_000,
            "value": amount
        }
    )
    signed_tx = w3.eth.account.sign_transaction(transaction, PRIVATE_KEY)
    txn_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
    print("waiting for transaction to complete:", txn_hash.hex())
    txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)


def approve(amount):
    transaction = weth_contract.functions.approve(selector_address, amount).build_transaction(
        {
            "from": ADDRESS,
            "nonce": w3.eth.get_transaction_count(ADDRESS),
            "gas": 360_000
        }
    )
    signed_tx = w3.eth.account.sign_transaction(transaction, PRIVATE_KEY)
    txn_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
    print("waiting for transaction to complete:", txn_hash.hex())
    txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)

amount = Web3.to_wei(0.01, "ether")
# amount = int(0.1 * 10e18)
# print(amount)
deposit(amount)
approve(amount)

# weth_contract.functions.approve(selector_address, 0.1 * 10e18)


# for dest in DEST_URLS:
#     w3_dest = Web3(Web3.HTTPProvider(dest["rpc"]))
#     for a in addresses:
#         balance = w3_dest.eth.get_balance(a)
#         print(f"current balance of {a}, {balance / 1e18}")
#         if balance < dest["threshold"]:
#             print("refilling")
#             quote = selector_contract.functions.getLayerZeroQuote(
#                 dest["dsteid"], dest["amount"], a
#             ).call()
#             transaction = selector_contract.functions.bridgeWithLayerZero(
#                 dest["dsteid"], dest["amount"], a, quote
#             ).build_transaction(
#                 {
#                     "from": ADDRESS,
#                     "nonce": w3.eth.get_transaction_count(ADDRESS),
#                     "gas": 360_000,
#                 }
#             )
#             signed_tx = w3.eth.account.sign_transaction(transaction, PRIVATE_KEY)
#             txn_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
#             print("waiting for transaction to complete:", txn_hash.hex())
#             txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)


# weth_address = selector_contract.functions.weth.call()

# with open('weth.json', 'r') as f:
#     weth_abi = f.read()
# weth_contract = w3.eth.contract(address=weth_address, abi=weth_abi)

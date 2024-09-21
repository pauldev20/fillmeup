# Fill me up
Never worry about gas fees again! Approve funds on one chain and all chains are automatically refilled.

## Problem
**Gas cost is annoying!**
You need to maintain gas on every chain you interact with, and eventually, you'll run out on some of them. 

## Solution
With this project, you can approve funds on a single chain. Whenever you're low on gas on any chain, your balance will automatically be filled up using those approved funds. This ensures you only spend the minimum necessary to keep just enough gas on all chains, saving you from the hassle of manual refills.

## Technical
This project utilizes an intermediary contract to which users approve their funds. 
A central service monitors the gas levels of users who have approved funds. When a user's gas is low, the service calls the intermediary contract, which uses the approved allowance to transfer some funds to itself. It then swaps and bridges the funds to the chain that is running low. 
Since the contract can only transfer funds to the same user address on another chain, users maintain complete control and security, with no risk of losing their assets.

```mermaid
sequenceDiagram
    actor User
    participant I as IntermediaryContract
    participant Service

    User->>I: approve(intermediary)
    I<<-->>Service: Listen for Approval event
    activate Service
    Note over Service,Service: Check for funds on other chains 
    alt little funds
        Service->>I: Trigger fill up
        User-->>I: transferFrom(user, intermediary)
        Note over I,I: Initiate swap & bridge 
    end
    deactivate Service
```

## Contracts

### LayerZero
[sepolia](https://sepolia.etherscan.io/address/0x13b50021965171557cB0d6f3a2AAF1F86fCDEA94)

[base-sepolia](https://sepolia.basescan.org/address/0x83473d55A8b4415B980d51EC9753c8Fb19D26f82)

[arbitrum-sepolia](https://sepolia.arbiscan.io/address/0x0b18692D2f4059F13baA765816bFBD07776F7D8B)

[polygon-amoy](https://www.oklink.com/amoy/address/0x0b18692D2f4059F13baA765816bFBD07776F7D8B)

[optimism-sepolia](https://sepolia-optimism.etherscan.io/address/0x0b18692D2f4059F13baA765816bFBD07776F7D8B)

[morph](https://explorer-holesky.morphl2.io/address/0x0b18692D2f4059F13baA765816bFBD07776F7D8B)

### BridgeSelector

[sepolia](https://sepolia.etherscan.io/address/0x290e31032c33331d724298544663db502c8cc77d)



"use client";

import { useWeb3Modal, useWeb3ModalState, useWeb3ModalAccount } from "@web3modal/ethers5/react";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";
import { ReloadIcon } from "@radix-ui/react-icons";

export default function ConnectButton() {
	const { open: modalOpen } = useWeb3ModalState();
	const { isConnected } = useWeb3ModalAccount();
	const { open } = useWeb3Modal();
	const [connected, setConnected] = useState(false);
	const [connecting, setConnecting] = useState(false);

	useEffect(() => {
		setConnected(isConnected);
	}, [isConnected]);
	const openMod = () => {
		open({view: "Connect"});
	}
	useEffect(() => {
		setConnecting(!connected && modalOpen);
	}, [connected, modalOpen])

	return (
		<>
			<div hidden={!connected}>
				<w3m-account-button/>
			</div>
			<div hidden={connected}>
				<Button onClick={openMod} disabled={connecting}>
					{connecting ? <ReloadIcon className="mr-2 h-4 w-4 animate-spin" /> : <></>}
					{connecting ? "Connecting" : "Connect Wallet"}
				</Button>
			</div>
		</>
	)
}
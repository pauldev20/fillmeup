"use client";

import { useAppKit, useAppKitAccount, useAppKitState } from '@reown/appkit/react';
import { ReloadIcon } from "@radix-ui/react-icons";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";

export default function ConnectButton() {
	const [connecting, setConnecting] = useState(false);
	const [connected, setConnected] = useState(false);
	const { open: modalOpen } = useAppKitState();
	const { isConnected } = useAppKitAccount();
	const { open } = useAppKit();

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
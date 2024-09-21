import { useAppKitProvider, useAppKitAccount } from "@reown/appkit/react";
import { BrowserProvider, Contract, formatUnits, parseUnits } from 'ethers';
import { useCallback, useEffect, useState } from "react";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import WETHAbi from "@/public/erc20abi.json";
import { EIP1193Provider } from "viem";

const WETHAddress = process.env.NEXT_PUBLIC_WETH_CONTRACT as string;
const ApproveContract = process.env.NEXT_PUBLIC_DIST_CONTRACT as string;

interface ApprovalWidgetProps {
	callback?: (hasWeth: boolean, hasApproval: boolean) => void;
}

export default function ApprovalWidget({ callback }: ApprovalWidgetProps) {
	const { address, isConnected } = useAppKitAccount();
	const { walletProvider } = useAppKitProvider('eip155');
	const [approved, setApproved] = useState<number | null>(null);
	const [balance, setBalance] = useState<number | null>(null);
	const [disabled, setDisabled] = useState(true);
	const [amount, setAmount] = useState(0.0);


	const getAllowance = useCallback(async () => {
		console.log('getAllowance', WETHAddress);
		if (!isConnected) return;
		setApproved(null);
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const allowance = await WETHContract.allowance(address, ApproveContract);
		setApproved(Number(formatUnits(allowance, 18)));
	}, [address, isConnected, walletProvider]);
	const getBalance = useCallback(async () => {
		if (!isConnected) return;
		setBalance(null);
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const balance = await WETHContract.balanceOf(address);
		console.log(address, balance);
		setBalance(Number(formatUnits(balance, 18)));
	}, [address, isConnected, walletProvider]);

	const approveWeth = async () => {
		if (!isConnected) return;
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const transaction = await WETHContract.approve(ApproveContract, parseUnits(amount.toString(), 18))
		setApproved(null);
		await transaction.wait();
		getAllowance();
	}
	const revokeWeth = async () => {
		if (!isConnected) return;
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const transaction = await WETHContract.approve(ApproveContract, 0);
		setApproved(null);
		await transaction.wait();
		getAllowance();
	}

	useEffect(() => {
		setDisabled(!isConnected);
		getAllowance();
		getBalance();
	}, [isConnected, getAllowance, getBalance]);

	useEffect(() => {
		if (balance == null || approved == null) return;
		if (callback) callback(balance > 0, approved > 0);
	}, [balance, approved, callback]);

	return (<>
		<div className="flex gap-3 justify-center items-center">
			<Input disabled={(approved || 0) > 0 || approved == null} className="w-40" step="any" type="number" placeholder="WETH Amount" onChange={(e) => setAmount(Number(e.target.value))} value={(approved || 0) > 0 || approved == null ? approved?.toPrecision(2) : undefined}/>
			<p className="text-lg">of</p>
			<div className="flex items-center justify-center gap-2 text-lg font-bold">
				{balance == null ? <Skeleton className="h-4 w-[60px]" /> : <span>{balance?.toPrecision(2)}</span>}
				<h1>WETH</h1>
			</div>
		</div>
		<div className="flex justify-center items-center gap-4">
			<Button disabled={disabled} onClick={(approved || 0) > 0 ? revokeWeth : approveWeth}>{(approved || 0) > 0 ? "Revoke WETH" : "Approve WETH"}</Button>
			<div className="flex items-center justify-center gap-2">
				{approved == null ? <Skeleton className="h-4 w-[50px]" /> : <span className="font-bold">{approved?.toPrecision(2)}</span>}
				<p><span className="font-bold">WETH</span> left</p>
			</div>
		</div>
	</>)
}

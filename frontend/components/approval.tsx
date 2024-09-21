import { useAppKitProvider, useAppKitAccount } from "@reown/appkit/react";
import { BrowserProvider, Contract, formatUnits, parseUnits } from 'ethers';
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { EIP1193Provider } from "viem";
import { useCallback, useEffect, useState } from "react";

const WETHAddress = '0x4200000000000000000000000000000000000006';

const WETHAbi = [{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"guy","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"dst","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"dst","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Withdrawal","type":"event"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"guy","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"deposit","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"src","type":"address"},{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];

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
		if (!isConnected) return;
		setApproved(null);
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const allowance = await WETHContract.allowance(address, address);
		setApproved(Number(formatUnits(allowance, 18)));
	}, [address, isConnected, walletProvider]);
	const getBalance = useCallback(async () => {
		if (!isConnected) return;
		setBalance(null);
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const balance = await WETHContract.balanceOf(address);
		setBalance(Number(formatUnits(balance, 18)));
	}, [address, isConnected, walletProvider]);

	const approveWeth = async () => {
		if (!isConnected) return;
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const transaction = await WETHContract.approve(address, parseUnits(amount.toString(), 18))
		setApproved(null);
		await transaction.wait();
		getAllowance();
	}
	const revokeWeth = async () => {
		if (!isConnected) return;
		const ethersProvider = new BrowserProvider(walletProvider as EIP1193Provider);
		const signer = await ethersProvider.getSigner()

		const WETHContract = new Contract(WETHAddress, WETHAbi, signer);
		const transaction = await WETHContract.approve(address, 0);
		await transaction.wait();
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
				<p>WETH left for gas</p>
			</div>
		</div>
	</>)
}

'use client';

import { createAppKit } from '@reown/appkit/react'
import { EthersAdapter } from '@reown/appkit-adapter-ethers';
import { base, sepolia } from '@reown/appkit/networks';
import { ReactNode } from 'react';

// 1. Get projectId at https://cloud.reown.com
const projectId = 'd04be838f7df7941bffb294d5c32eb3a';

// 2. Set Ethers adapters
const ethers5Adapter = new EthersAdapter()

// 3. Create a metadata object
const metadata = {
  name: 'FillMeUp',
  description: 'Say goodbye to gas worries!',
  url: 'https://fillmeup-two.vercel.app',
  icons: ['https://assets.reown.com/reown-profile-pic.png']
}

// 4. Create the AppKit instance
createAppKit({
  adapters: [ethers5Adapter],
  metadata: metadata,
  networks: [base, sepolia],
  defaultNetwork: sepolia,
  projectId,
  allowUnsupportedChain: true,
  features: {
    onramp: false,
    analytics: false,
    swaps: true
  }
})

export function AppKit({ children }: { children: ReactNode }) {
  return children
}

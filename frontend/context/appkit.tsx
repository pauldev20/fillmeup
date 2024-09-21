'use client';

import { EthersAdapter } from '@reown/appkit-adapter-ethers';
import { base, sepolia } from '@reown/appkit/networks';
import { createAppKit } from '@reown/appkit/react'
import { ReactNode } from 'react';

const projectId = 'd04be838f7df7941bffb294d5c32eb3a';

const ethers5Adapter = new EthersAdapter()

const metadata = {
  name: 'FillMeUp',
  description: 'Say goodbye to gas worries!',
  url: 'https://fillmeup-two.vercel.app',
  icons: ['https://assets.reown.com/reown-profile-pic.png']
}

createAppKit({
  adapters: [ethers5Adapter],
  metadata: metadata,
  networks: [base, sepolia],
  defaultNetwork: sepolia,
  projectId,
  allowUnsupportedChain: true,
  features: {
    socials: false,
    email: false,
    onramp: false,
    analytics: false,
    swaps: true
  }
})

export function AppKit({ children }: { children: ReactNode }) {
  return children
}

"use client";

import SpeechBubble, {SpeechBubbleHandle} from "@/components/speechbubble";
import { useOnMountUnsafe } from "@/lib/useOnMountUnsafe";
import ConnectButton from "@/components/w3button";
import { useAppKit, useAppKitAccount } from "@reown/appkit/react";
import { Button } from "@/components/ui/button";
import { useEffect, useRef, useState } from "react";
import Image from "next/image";
import ApprovalWidget from "@/components/approval";
import { Londrina_Solid } from 'next/font/google';
import LetterPullup from "@/components/magicui/letter-pullup";
import {
  Card,
  CardContent,
} from "@/components/ui/card";

const londrinaSolid = Londrina_Solid({ weight: "400", subsets: ["latin"] });


export default function Home() {
  const speechRef = useRef<SpeechBubbleHandle>(null);
  const [disabled, setDisabled] = useState(true);
  const { isConnected, status } = useAppKitAccount();
  const { open } = useAppKit();

  useOnMountUnsafe(() => {
    if (!speechRef.current) return;
    speechRef.current.addMessage("Hello, I'm Gassy!");
    speechRef.current.addMessage("I'm here to help you with your gas fees!");
  });

  useEffect(() => {
    setDisabled(!isConnected);
    if (!speechRef.current) return;
    if (status === "connected") {
      speechRef.current.addMessage("Looks like your wallet is connected!");
    }
    if (status === "disconnected") {
      speechRef.current.addMessage("Please connect your wallet to get started!");
    }
  }, [speechRef, isConnected, status]);

  const handleMessageCallback = (hasWeth: boolean, hasApproval: boolean) => {
    if (!speechRef.current) return;
    if (hasWeth && !hasApproval) {
      speechRef.current.addMessage("You have WETH! Please approve it!");
    }
    if (hasWeth && hasApproval) {
      speechRef.current.addMessage("You have WETH and approved it! Lay back and I'll fill you up!");
    }
    if (!hasWeth) {
      speechRef.current.addMessage("You don't have WETH! To continue, please swap some!");
    }
  }

  return (
    <div className="min-h-screen">
      <header className="flex flex-col gap-4 items-end w-full absolute p-4">
        <ConnectButton/>
      </header>
      <main className="flex items-center justify-center min-h-screen">
        <div className="absolute top-0 mt-20 -rotate-6">
          <LetterPullup
            className={londrinaSolid.className}
            words={"Say goodbye to gas worries!"} delay={0.05}
          />
        </div>
        <Card className="w-[700px] p-8 !overflow-visible bg-[#e3cd96] z-10 border-none shadow-lg">
          <CardContent>
          <div className="flex flex-col gap-5">

            <div className="flex gap-3">

              <div className="flex flex-col gap-3">
                <div className="flex flex-col gap-3">
                  <h1 className="flex items-center">
                    <span className="text-4xl mr-2">①</span>Swap to get some WETH
                  </h1>
                  <div className="flex justify-center items-center">
                      {/* @ts-expect-error type missing but working */}
                      <Button onClick={() => open({view: "Swap"})} disabled={disabled}>Swap WETH</Button>
                  </div>
                </div>
                <hr className="border-t-2 border-gray-800 mx-12"/>
                <div className="flex flex-col gap-3">
                  <h1 className="flex items-center">
                    <span className="text-4xl mr-2">②</span>Approve WETH for your gas on all chains
                  </h1>
                  <ApprovalWidget callback={handleMessageCallback}/>
                </div>
                <hr className="border-t-2 border-gray-800 mx-12"/>
                <div className="flex flex-col gap-3">
                  <h1 className="flex items-center">
                    <span className="text-4xl mr-2">③</span>Enjoy the gas on all the chains
                  </h1>
                </div>
              </div>

              <div className="flex flex-col items-center justify-center">
                <div className="relative">
                  <Image src="/noun.png" width={250} height={250} alt="Nouns Character" />
                  <SpeechBubble
                    ref={speechRef}
                    className="absolute left-full top-0 w-60 -ml-12 mt-20 transform -translate-y-full"
                  />
                </div>
              </div>

            </div>

            {/* <hr className="border-t-2 border-gray-300 mx-3"/>
            <div>
              <h1 className="text-center text-lg font-bold">Transactions</h1>
            </div> */}
          </div>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}

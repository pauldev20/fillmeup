"use client";

import SpeechBubble, {SpeechBubbleHandle} from "@/components/speechbubble";
import { useOnMountUnsafe } from "@/lib/useOnMountUnsafe";
import ConnectButton from "@/components/w3button";
import { useAppKit } from "@reown/appkit/react";
import { Button } from "@/components/ui/button";
import { useRef } from "react";
import Image from "next/image";
import ApprovalWidget from "@/components/approval";
// import Image from "next/image";

export default function Home() {
  const speechRef = useRef<SpeechBubbleHandle>(null);
  const { open } = useAppKit();

  useOnMountUnsafe(() => {
    console.log("Hello, I'm Gassy!");
    if (!speechRef.current) return;
    speechRef.current.addMessage("Hello, I'm Gassy!");
    speechRef.current.addMessage("I'm here to help you with your gas fees!");
  });

  return (
    <div className="min-h-screen">
      <header className="flex flex-col gap-4 items-end w-full absolute p-4">
        <ConnectButton/>
      </header>
      <main className="flex items-center justify-center min-h-screen w-full">
        <div className="flex flex-col gap-5">

          <div className="flex gap-3">

            <div className="flex flex-col gap-3">
              <div className="flex flex-col gap-3">
                <h1 className="flex items-center">
                  <span className="text-4xl mr-2">①</span>Swap to get some WETH
                </h1>
                <div className="flex justify-center items-center">
                    {/* @ts-expect-error type missing but working */}
                    <Button onClick={() => open({view: "Swap"})}>Swap WETH</Button>
                </div>
              </div>
              <hr className="border-t-2 border-gray-300 mx-12"/>
              <div className="flex flex-col gap-3">
                <h1 className="flex items-center">
                  <span className="text-4xl mr-2">②</span>Approve WETH for your gas on all Chains
                </h1>
                <ApprovalWidget/>
              </div>
              <hr className="border-t-2 border-gray-300 mx-12"/>
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
      </main>
    </div>
  );
}

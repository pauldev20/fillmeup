"use client";

import ConnectButton from "@/components/w3button";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import Image from "next/image";
import SpeechBubble from "@/components/speechbubble";
import { useEffect, useState } from "react";
// import Image from "next/image";

export default function Home() {
  const [speachText, setSpeachText] = useState("Hello my name is Gassy!");

  useEffect(() => {
    setTimeout(() => {
      setSpeachText("I'm here to help you with your gas fees!");
    }, 1000
    );
  }, []);

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
                  <Button>Approve WETH</Button>
                </div>
              </div>
              <hr className="border-t-2 border-gray-300 mx-12"/>
              <div className="flex flex-col gap-3">
                <h1 className="flex items-center">
                  <span className="text-4xl mr-2">②</span>Approve WETH for your gas on all Chains
                </h1>
                <Input placeholder="Enter WETH amount" />
                <div className="flex justify-center items-center gap-4">
                  <Button>Approve WETH</Button>
                  <p><span className="font-bold">77,5</span> WETH left for gas</p>
                </div>
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
                  text={speachText}
                  className="absolute left-full top-0 w-60 -ml-12 mt-20 transform -translate-y-full"
                />
              </div>
            </div>

          </div>

          <hr className="border-t-2 border-gray-300 mx-3"/>
          <div>
            <h1 className="text-center text-lg font-bold">Transactions</h1>
          </div>
        </div>
      </main>
    </div>
  );
}

import styles from './styles.module.css';
import { cn } from "@/lib/utils";
import React, { useState, useImperativeHandle, useRef, useEffect, useCallback } from 'react';

export interface SpeechBubbleHandle {
  addMessage: (message: string) => void;
  clearMessages: () => void;
}

interface SpeechBubbleProps extends React.HTMLAttributes<HTMLDivElement> {
  typingSpeed?: number;
  messageDelay?: number;
}

const SpeechBubble = React.forwardRef<SpeechBubbleHandle, SpeechBubbleProps>(
	(
	  {
		className,
		typingSpeed = 45,
		messageDelay = 700,
		...props
	  },
	  ref
	) => {
	  const [messagesQueue, setMessagesQueue] = useState<string[]>([]);
	  const [currentMessage, setCurrentMessage] = useState<string | null>(null);
	  const [lastMessage, setLastMessage] = useState<string | null>(null);
	  const [displayedText, setDisplayedText] = useState<string>("");
	  const isTyping = useRef(false);
	  const typingIntervalRef = useRef<NodeJS.Timeout | null>(null);
	  const delayTimerRef = useRef<NodeJS.Timeout | null>(null);
  
	  useImperativeHandle(ref, () => ({
		addMessage: (message: string) => {
		  if (message.trim() !== "") {
			setMessagesQueue((prevQueue) => [...prevQueue, message]);
		  }
		},
		clearMessages: () => {
		  setMessagesQueue([]);
		  setCurrentMessage(null);
		  setLastMessage(null);
		  setDisplayedText("");
		  isTyping.current = false;
		  if (typingIntervalRef.current) {
			clearInterval(typingIntervalRef.current);
			typingIntervalRef.current = null;
		  }
		  if (delayTimerRef.current) {
			clearTimeout(delayTimerRef.current);
			delayTimerRef.current = null;
		  }
		},
	  }));
  
	  useEffect(() => {
		return () => {
		  if (typingIntervalRef.current) {
			clearInterval(typingIntervalRef.current);
		  }
		  if (delayTimerRef.current) {
			clearTimeout(delayTimerRef.current);
		  }
		};
	  }, []);
  
	  const startNextMessage = useCallback(() => {
		if (messagesQueue.length > 0) {
		  const nextMessage = messagesQueue[0];
		  setMessagesQueue((prevQueue) => prevQueue.slice(1));
		  setCurrentMessage(nextMessage);
		  setDisplayedText("");
		  isTyping.current = true;
  
		  let charIndex = 0;
  
		  typingIntervalRef.current = setInterval(() => {
			charIndex += 1;
			setDisplayedText(nextMessage.slice(0, charIndex));
  
			if (charIndex >= nextMessage.length) {
			  if (typingIntervalRef.current) {
				clearInterval(typingIntervalRef.current);
				typingIntervalRef.current = null;
			  }
			  setLastMessage(nextMessage);
  
			  delayTimerRef.current = setTimeout(() => {
				isTyping.current = false;
				setCurrentMessage(null);
			  }, messageDelay);
			}
		  }, typingSpeed);
		}
	  }, [messageDelay, messagesQueue, typingSpeed]);

	  useEffect(() => {
		if (!isTyping.current && !currentMessage && messagesQueue.length > 0) {
		  startNextMessage();
		}
	  }, [messagesQueue, currentMessage, startNextMessage]);
  
	  const messageToDisplay = isTyping.current ? displayedText : lastMessage;
  
	  return (
		<div className={className} {...props}>
		  <div
			className={cn([
			  "relative inline-block bg-white text-black font-bold text-center p-2 px-4",
			  styles.pixelShadow,
			])}
		  >
			{messageToDisplay ? (
			  <span className="text-sm">
				{messageToDisplay}
				{isTyping.current && <span className={styles.typingCursor}></span>}
			  </span>
			) : (
			  <span className="text-sm">&nbsp;</span>
			)}
		  </div>
		  <div className={styles.speechArrow}>
			<div className={styles.arrowW}></div>
			<div className={styles.arrowX}></div>
			<div className={styles.arrowY}></div>
			<div className={styles.arrowZ}></div>
		  </div>
		</div>
	  );
	}
  );
  
  SpeechBubble.displayName = "SpeechBubble";
  
  export default SpeechBubble;

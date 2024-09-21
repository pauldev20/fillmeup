import styles from './styles.module.css';
import { cn } from "@/lib/utils";
import React from 'react';

export interface BubbleProps extends React.HTMLAttributes<HTMLDivElement> {
	text: string
}

const SpeechBubble = React.forwardRef<HTMLDivElement, BubbleProps>(
	({ className, text, ...props }, ref) => {
		return (
			<div className={className} ref={ref} {...props}>
				<div className={cn(["relative inline-block bg-white text-black font-bold text-center p-2 px-4", styles.pixelShadow])}>
					{text}
				</div>
				<div className={styles.speechArrow}>
					<div className={styles.arrowW}></div>
					<div className={styles.arrowX}></div>
					<div className={styles.arrowY}></div>
					<div className={styles.arrowZ}></div>
				</div>
			</div>
		)
	}
)
SpeechBubble.displayName = "SpeechBubble"

export default SpeechBubble;

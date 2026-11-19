# 01 – Problem Analysis
Problem Number/title:
Number/title: 7H3 – Weather Alert System with Error State for Invalid Input

Problem summary:
Design and simulate a synchronous Moore Finite State Machine (FSM) based Weather Alert System that samples digital wind speed inputs, classifies them into specific weather categories (Calm, Breezy, Storm), and incorporates an additional ERROR state (Hint H3) to flag out-of-range wind inputs (> 7). The system must remain in an idle state initially, transition upon a start signal, and return to the idle state when acknowledged or reset.

Objective:
To store incoming wind speed data using an input register and decode it into valid weather ranges (0–2: Calm, 3–5: Breezy, 6–7: Storm) or an invalid range (> 7: Error).  
​To implement a 5-state Moore FSM (IDLE, CALM, BREEZY, STORM, ERROR) controlled by START, ACK, and RESET signals.  
​To drive visual indicator LEDs corresponding to the active FSM state and weather alert condition, ensuring all alert outputs stay OFF during IDLE and the ERROR indicator asserts for inputs exceeding 7.

Inputs and outputs:
​Inputs:
​W[3:0] (W3, W2, W1, W0 – 4-bit): Binary wind speed input switches (0 to 15). Expanded from 3 bits to 4 bits to detect values > 7.  
​START (1-bit): Control signal to sample the classified wind input and transition from IDLE to the corresponding weather/error state.  
​ACK (1-bit): Acknowledge signal to clear the active alert/error and return the FSM to the IDLE state.  
​RESET (1-bit): Asynchronous/synchronous clear signal that resets the input register and forces the FSM back to IDLE (000).  
​CLK (1-bit): System clock driving the input register and FSM state register.  
​Outputs:
​FSM State Indicators (5 LEDs): IDLE, CALM, BREEZY, STORM, and ERROR LEDs indicating the current internal state of the Moore FSM.  
​
Constraints and assumptions:
​4-Bit Input Width: Although the base problem specifies a 3-bit wind input (0–7), a 3-bit bus cannot represent values greater than 7 (111). To satisfy Hint H3 (> 7 error detection), the input bus and input register are scaled to 4 bits (0000 to 1111), treating 8–15 (1000–1111) as invalid inputs.  
​State Encoding: Five states require 3 flip-flops/bits in the state register (000: IDLE, 001: CALM, 010: BREEZY, 011: STORM, 100: ERROR). Unused state encodings (101–111) are safely prevented by combinational next-state logic.  
​Signal Priority: RESET overrides all operations to force IDLE, and ACK takes priority over START so an operator can always clear an active alarm or error.



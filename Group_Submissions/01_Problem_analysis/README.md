# 01 – Problem Analysis

## 1. Problem Statement

The objective of this project is to design and implement a 4-bit Fibonacci Number Detector using Verilog HDL and a Finite State Machine (FSM).

The system accepts a 4-bit binary input and determines whether the entered decimal number belongs to the Fibonacci sequence. For inputs ranging from 0 to 15, the Fibonacci numbers considered are:

**0, 1, 2, 3, 5, 8, 13**

The system indicates whether the input is a Fibonacci or Non-Fibonacci number using separate output signals. The detection process is controlled using START, ACK and RESET signals.

## 2. Functional Requirements

The system must satisfy the following requirements:

1. Accept a 4-bit binary input representing numbers from 0 to 15.
2. Detect whether the input belongs to the Fibonacci sequence.
3. Generate a Fibonacci indication when a valid Fibonacci number is detected.
4. Generate a Non-Fibonacci indication for numbers that do not belong to the sequence.
5. Use a START signal to initiate the detection process.
6. Use an ACK signal to acknowledge the result and return the FSM to its idle state.
7. Use RESET to initialize the system.
8. Display the detection result through output signals/LEDs.

## 3. Assumptions

- The input is an unsigned 4-bit binary number.
- Only integers between 0 and 15 are considered.
- The Fibonacci sequence is limited to 0, 1, 2, 3, 5, 8 and 13.
- The input is stable when START is activated.
- The system operates using a common clock signal.
- RESET initializes the FSM to its initial state.
- ACK is used to acknowledge the detection cycle and return the system to the idle state.

## 4. Input and Output Definitions

### Inputs

| Signal | Width | Description |
|---|---:|---|
| X | 4 bits | Binary number to be tested |
| clk | 1 bit | System clock |
| reset | 1 bit | Resets the FSM |
| start | 1 bit | Initiates number detection |
| ack | 1 bit | Acknowledges the result |

### Outputs

| Signal | Description |
|---|---|
| F | Detection result |
| FIB | Indicates that the input is a Fibonacci number |
| NON_FIB | Indicates that the input is not a Fibonacci number |

## 5. Design Constraints

- The design must be implemented using Verilog HDL.
- The input width is restricted to 4 bits.
- The system must use sequential and combinational logic appropriately.
- The FSM must operate synchronously with the clock.
- The design must be synthesizable on the Boolean Board Spartan-7 FPGA.
- The implementation must use the available switches, push buttons and LEDs on the FPGA board.
- No microcontroller is required for the detection logic.

## 6. Proposed Solution

The proposed solution uses a combination of combinational logic and a two-state Mealy Finite State Machine.

The design is divided into the following functional blocks:

1. **Input Module:** Accepts the 4-bit binary input and control signals.
2. **Fibonacci Detection Module:** Compares the input against the predefined Fibonacci numbers and generates the detection result.
3. **FSM Controller:** Controls the operation of the system using two states: IDLE (S1) and WAIT_ACK (S2).
4. **State Register:** Stores the current FSM state and updates it according to clock and control signals.
5. **Output Module:** Generates the Fibonacci and Non-Fibonacci indication signals.

When START is activated in the IDLE state, the detector evaluates the input and generates the corresponding result. The FSM then transitions to the WAIT_ACK state. After receiving ACK, the FSM returns to the IDLE state, allowing another detection cycle.

This approach provides a simple, modular and hardware-efficient implementation of a Fibonacci number detector.

# Problem Analysis

## 1. Problem Statement
The objective of this project is to design a 3-bit Water Temperature Classifier using digital logic circuits and a Mealy Finite State Machine (FSM). The system classifies the given digital temperature input into three categories: COLD, NEUTRAL, and HOT. The corresponding output is activated based on the temperature range and control signals.

## 2. Requirements
- Accept a 3-bit digital temperature input.
- Store the temperature input using a 3-bit register.
- Classify the input into COLD, NEUTRAL, or HOT.
- Use comparators and logic gates for temperature range detection.
- Implement an FSM using the Mealy model.
- Use START to initiate classification.
- Use ACK to return the FSM to the IDLE state.
- Use RESET to initialize the system.
- Display the classification using three output LEDs.

## 3. Input Definitions

| Input | Description |
|---|---|
| T2, T1, T0 | 3-bit digital temperature input |
| CLK | Clock signal for synchronization |
| START | Starts the classification process |
| ACK | Acknowledgement signal |
| RESET | Resets the FSM to its initial state |

## 4. Output Definitions

| Output | Description |
|---|---|
| COLD | Indicates a cold temperature |
| NEUTRAL | Indicates a neutral temperature |
| HOT | Indicates a hot temperature |

## 5. Temperature Classification

The 3-bit input represents values from 0 to 7. The classification is defined as follows:

| Temperature Input | Classification |
|---|---|
| 000–010 (0–2) | COLD |
| 011–101 (3–5) | NEUTRAL |
| 110–111 (6–7) | HOT |

Only one classification output should be active at a time.

## 6. Constraints
- The system uses a 3-bit temperature input.
- Only eight input combinations (0–7) are possible.
- A 3-bit register is used to store the input.
- The system operates using a clock signal.
- The FSM consists of two states: IDLE and WAIT_ACK.
- The design uses a Mealy FSM.
- The classification outputs are controlled by the FSM and temperature decoder.
- RESET initializes the FSM to IDLE.

## 7. Assumptions
- The digital temperature value is already available at the input switches.
- The input remains stable during the register capture operation.
- All eight binary input combinations are valid.
- The FSM starts in the IDLE state after reset.
- The temperature ranges are predefined.
- The output LEDs represent the three temperature categories.

## 8. Proposed Solution
The proposed system consists of a 3-bit input register, comparator-based temperature decoder, Mealy FSM controller, and three output LEDs.

First, the 3-bit temperature input is stored in the register using the clock signal. The stored value is then passed to the comparator-based decoder, which checks the input against the predefined temperature ranges.

The decoder generates three signals: COLD, NEUTRAL, and HOT. The Mealy FSM controls the classification process using the START, ACK, and RESET signals.

The FSM operates in two states:
- **S1 – IDLE:** The system waits for the START signal.
- **S2 – WAIT_ACK:** The system waits for the acknowledgement signal.

When START is activated, the system evaluates the stored temperature and generates the corresponding classification output. When ACK is activated, the FSM returns to the IDLE state. RESET initializes the FSM to IDLE and turns off all classification outputs.

The design will be implemented and tested using Logisim Evolution and Verilog HDL with Xilinx Vivado.

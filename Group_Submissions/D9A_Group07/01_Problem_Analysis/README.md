# 01 – Problem Analysis

## 1. Problem Statement
**Title:** Forbidden Zone Rejector (4-bit)
**Problem statement number:** 6-H2

Design a circuit that outputs 0 for the binary values 0110 to 1001 (decimal 6 to 9, inclusive) and 1 for all other values.

**Modification chosen:** H2 – Mealy FSM with Immediate Output.
The original design is a Moore FSM, which waits for the next clock before the LED changes. In H2 the ACCEPT/REJECT output must react immediately to the current input X[3:0], without waiting for the next clock.

## 2. Requirements
1. Read a 4-bit input X[3:0] (values 0 to 15).
2. Detect the forbidden zone (6 to 9).
3. Output Y = 1 (ACCEPT, green LED) for allowed values and Y = 0 (REJECT, red LED) for forbidden values.
4. The output must change immediately when X changes (Mealy behaviour, no clock wait).
5. Remember a rejection until it is acknowledged (ACK) or the system is reset (RESET).
6. Implement in Logisim, then in Verilog, verify with a testbench for all 16 inputs, and run on the FPGA board.

## 3. Input / Output Definition
| Signal | Direction | Width | Meaning |
|---|---|---|---|
| X[3:0] | Input | 4 bits | Binary number set on the switches |
| ACK | Input | 1

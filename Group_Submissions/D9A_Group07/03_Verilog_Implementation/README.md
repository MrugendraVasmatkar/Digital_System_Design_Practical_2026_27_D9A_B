# 03 – Verilog Implementation

## Overview
Verilog implementation of the Forbidden Zone Rejector as a **Mealy FSM with immediate output (H2)**. The design rejects inputs 6 to 9 (0110 to 1001) and accepts all other values. The output Y depends on the present state and the present input, so it changes without waiting for a clock edge.

## Tool and Version
- Vivado 2018.3, simulator: Vivado Simulator (XSim)
- Target device: Spartan-7 xc7s50csga324-1 (Real Digital Boolean)

## Files
| Folder | File | Purpose |
|---|---|---|
| RTL/ | FRZ.v | Top module: FSM + forbidden-zone logic |
| Testbench/ | FRZ_tb.v | Testbench for all 16 input values, ACK and RESET |
| Simulation_Results/ | Waveform | Waveform screenshot |
| Simulation_Results/ | Log file | Console log with PASS/FAIL messages |

## Module Description
**Top module:** FRZ.v

| Port | Direction | Width | Meaning |
|---|---|---|---|
| X3, X2, X1 | Input | 1 each | Input bits (X0 is not used in the logic) |
| ACK | Input | 1 | Acknowledge, returns REJECT to IDLE |
| RESET | Input | 1 | Asynchronous active-high clear |
| CLK | Input | 1 | Clock for the state flip-flop |
| Y | Output | 1 | ACCEPT (1) / REJECT (0), immediate |
| Y_bar | Output | 1 | Inverse of Y, REJECT LED |

## Architecture and Coding Decisions
- Forbidden zone: `FZ = (~X3 & X2 & X1) | (X3 & ~X2 & ~X1)`
- One state register Q (IDLE = 0, REJECT = 1), updated on the rising clock edge with an asynchronous reset.
- Next state: `D = (~Q & FZ) | (Q & ~ACK)`
- Output (Mealy): `Y = ~Q & ~FZ`, written with a continuous `assign`, so there is no clock or flip-flop in the path from X to Y.
- Y_bar is the inverse of Y.
- The Verilog follows the same gates as our Logisim circuit, so the two can be compared directly.

## Synthesizability
- No delays (`#`) or initial blocks in the RTL.
- State register in a clocked `always` block; output logic uses `assign`.
- No latches (every path assigns a value).
- The design fits easily on the xc7s50csga324-1.

## Testbench (FRZ_tb)

The testbench `FRZ_tb.v` instantiates the design (`FRZ dut`), generates a 10 ns clock, and applies the following test sequence. Results are verified by inspecting the waveform.

| Step | Stimulus | Expected result | What it proves |
|---|---|---|---|
| 1 | ACK = 1 for 12 ns, X = 000 | Q cleared to IDLE (0) | Initialization via ACK |
| 2 | X3X2X1 stepped through 000 to 111, 2 ns each, Q = 0 | Y = 0 only for 011 (6, 7) and 100 (8, 9), Y = 1 otherwise; Y changes immediately, without waiting for a clock edge | Mealy immediate output, forbidden zone logic |
| 3 | X = 011 at a rising clock edge, then X changed to 000 and 101 | Q = 1 (REJECT); Y stays 0 even though X is now allowed | Rejection is latched (state memory) |
| 4 | ACK = 1 at the next clock edge | Q returns to 0; Y returns to 1 | ACK returns the FSM to IDLE |

Note: X0 is not driven because it is a don't care and is not used in the logic.

- Tool: Vivado Simulator (XSim)
- Tests passed / failed: [fill in after you run it and check the waveform]
- Waveform: `Simulation_Results/Waveform`


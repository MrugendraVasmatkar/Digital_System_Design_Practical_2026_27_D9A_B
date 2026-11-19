# 01 – Problem Analysis

## Problem statement
**Gray Code Transition Detector (4-bit)** – design a circuit that outputs 1 only when two consecutive 4-bit inputs differ by exactly one bit (a valid Gray code transition).

**Selected modification:** **H1 – N-bit Gray Code Transition Detector** (parameterizable N ≥ 4, verified for N = 4, 5 and 8).

## Requirements
1. Capture the current input `X` and keep the previous input `P` in registers.
2. Compute the difference vector `D = X ⊕ P` (bitwise XOR).
3. One-bit-change detector: `V = 1` only when exactly one bit of `D` is 1.
   - General N-bit form (H1): `V = (ΣDᵢ) · ¬(Σ_{i<j} Dᵢ·Dⱼ)`.
   - 4-bit form from the sheet: `V = (D3+D2+D1+D0) · ¬(D3D2 + D3D1 + D3D0 + D2D1 + D2D0 + D1D0)`.
4. Moore FSM controller with state encoding `00 IDLE`, `01 VALID`, `10 INVALID`.
5. Indicator outputs: VALID LED (V = 1, exactly one bit changed) and INVALID LED (V = 0, zero or more than one bit changed). In IDLE both LEDs are off.
6. Control inputs: `START` (load a sample), `ACK` (return to IDLE), `RESET` (synchronous, active-high).

## Inputs and outputs
| Signal | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | System clock (100 MHz on the FPGA) |
| `rst` | Input | 1 | Synchronous, active-high reset (clears X, P and the FSM) |
| `start` | Input | 1 | Rising edge loads the switches into X and moves old X into P |
| `ack` | Input | 1 | Returns the FSM to IDLE; has priority over `start` |
| `data_in` | Input | N | Input switches `X[N-1:0]` |
| `valid_led` | Output | 1 | Exactly one bit differs from the previous sample |
| `invalid_led` | Output | 1 | Zero bits or more than one bit differ |
| `idle_led` | Output | 1 | FSM is in IDLE (extra indicator) |
| `state_out` | Output | 2 | FSM state (debug) |
| `curr_out`, `prev_out` | Output | N | Registers X and P (debug) |
| `v_out` | Output | 1 | One-bit-change detector output (debug) |

## Assumptions and edge cases
- After reset `X = P = 0…0`, so the first sample is compared with all zeros (this matches the example table on the problem sheet: Prev 0000, Curr 0001).
- A held `START` button counts as **one** sample (rising-edge detection); the testbench checks this.
- `ACK` and `START` in the same cycle: `ACK` wins, the sample is ignored and P/X are unchanged.
- Same value twice (no change) → INVALID; two or more changed bits → INVALID; the MSB changing alone is a valid transition.
- The result is evaluated one clock cycle after the sample is loaded (X and P are registered first, then V is evaluated), so the FSM output appears two clock edges after `START` is first seen.

## Proposed solution
Datapath (input register X, previous register P, XOR array, one-bit-change detector) plus a Moore FSM controller (state register, next-state logic, output logic), exactly as in the "Complete System Block Diagram" of the problem sheet. The detector uses the generalised pair-wise formula from H1, so the same RTL works for any N.

## Sample sequence (from the problem sheet, N = 4)
| Prev P | Curr X | D = X ⊕ P | V |
|---|---|---|---|
| 0000 | 0001 | 0001 | 1 |
| 0001 | 0011 | 0010 | 1 |
| 0011 | 0111 | 0100 | 1 |
| 0111 | 0101 | 0010 | 1 |
| 0101 | 1101 | 1000 | 1 |
| 1101 | 1100 | 0001 | 1 |
| 1100 | 1111 | 0011 | 0 |

# 03 – Verilog Implementation

Place synthesizable RTL in `RTL/`, testbenches/test vectors in `Testbench/`, and waveforms/logs/verification summaries in `Simulation_Results/`.

## Files
| File | Purpose |
|---|---|
| `RTL/gray_code_nbit.v` | Design: parameter `N` (default 4), previous-input register, general one-bit-change detector and Moore FSM; also the FPGA top module |
| `Testbench/gray_code_nbit_tb.v` | Self-checking testbench with a 4-bit (N = 4) and a 5-bit (N = 5, H1 check) instance |
| `Simulation_Results/` | To be filled with the simulator log and waveform screenshots |

## Design summary (`gray_code_nbit`)
| Port | Dir. | Width | Description |
|---|---|---:|---|
| `clk` | In | 1 | Clock |
| `rst` | In | 1 | Synchronous, active-high reset (state = IDLE, P = 0) |
| `start` | In | 1 | Take a sample (accepted in IDLE) |
| `ack` | In | 1 | Return to IDLE from VALID/INVALID |
| `x` | In | N | Input switches |
| `valid_led` | Out | 1 | Lit in state VALID |
| `invalid_led` | Out | 1 | Lit in state INVALID |

- **Previous register:** `p` (N bits) holds the previous accepted input; it is 0 after reset.
- **Difference and detector (H1):** `d = x ^ p`; `at_least_one = |d`; `at_most_one = ~|(d & (d - 1))`; `v = at_least_one & at_most_one` – exactly one bit of `d` is 1, for any N.
- **Moore FSM:** `IDLE = 00`, `VALID = 01`, `INVALID = 10`.
  - In `IDLE`, when `start = 1`: `p <= x` and the next state is `VALID` if `v = 1`, otherwise `INVALID`.
  - In `VALID` or `INVALID`, `ack = 1` returns to `IDLE`; `start` is ignored until then.
  - Outputs depend only on the state (`valid_led = (state == VALID)`, `invalid_led = (state == INVALID)`); in `IDLE` both are off.
- **Reset:** synchronous, active-high.

## Testbench (`gray_code_nbit_tb`)
- 100 MHz clock; each step sets `x`, pulses `start`, checks the LEDs one cycle later and then pulses `ack` to return to IDLE.
- **N = 4 sequence:** `0001, 0011, 0111, 0101, 1101, 1100, 1111, 1111, 1001`.
- **N = 5 sequence (H1):** `00010, 10010, 10111`.
- Prints `PASS`/`FAIL` for each step and a final `Summary: <n> PASSED, <m> FAILED`.

## How to simulate (Vivado)
1. Add `RTL/gray_code_nbit.v` as a design source and `Testbench/gray_code_nbit_tb.v` as a simulation source.
2. Set `gray_code_nbit_tb` as the simulation top and run behavioural simulation.
3. Save the Tcl console log and waveform screenshots in `Simulation_Results/`.

## Verification status
Testbench has **not been run yet**; results are to be recorded here and in the group `README.md`. Known item to check first: the step `1100 -> 1111` is labelled "1-bit change" and expects VALID, but `1100 ^ 1111 = 0011` is a two-bit change (V = 0, as in the problem sheet's example table), so that step is expected to report a FAIL until the expected value is corrected to INVALID.

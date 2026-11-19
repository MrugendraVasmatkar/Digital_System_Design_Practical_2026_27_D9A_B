# 03 – Verilog Implementation

Place synthesizable RTL in `RTL/`, testbenches/test vectors in `Testbench/`, and waveforms/logs/verification summaries in `Simulation_Results/`.

## Files
| File | Purpose |
|---|---|
| `RTL/gray_code_detector.v` | Core design: parameter `N`, datapath (X, P, one-bit-change detector) + Moore FSM |
| `RTL/gray_code_top_arty_s7.v` | FPGA top for Arty S7-50: switch synchroniser, button debouncers, LED mapping (N = 4) |
| `Testbench/tb_gray_code_detector.v` | Self-checking testbench (N = 4 and N = 8 DUTs, directed + 300 random tests) |
| `Simulation_Results/` | To be filled with waveform screenshots and the simulator log |

## Design summary
- **Datapath:** `X` ← `data_in` and `P` ← old `X` on a `START` rising edge; `D = X ^ P`.
- **Detector (H1):** `V = (ΣDᵢ) & ~(Σ_{i<j} DᵢDⱼ)` written as a synthesizable function with static loops, valid for any N.
- **FSM (Moore):** `IDLE=00`, `VALID=01`, `INVALID=10`; three-block style (state register, next-state logic, output logic). Outputs depend only on the state.
- **Timing:** X and P are registered on the load edge; an `eval` flag evaluates `V` on the next clock, so the FSM updates one cycle after the load. `ACK` has priority over `START`.
- **Reset:** synchronous, active-high.

## How to simulate (Vivado)
1. Add `RTL/gray_code_detector.v` as a design source and `Testbench/tb_gray_code_detector.v` as a simulation source.
2. Set `tb_gray_code_detector` as the simulation top and run behavioural simulation (about 40 µs).
3. The Tcl console prints `RESULT: ALL TESTS PASSED` when every check passes.

## Verification status
Testbench written; **not yet run in a simulator**. Record the pass/fail counts, tool version and waveform screenshots in `Simulation_Results/` and in the group `README.md` once simulated.

# 03 – Verilog Implementation

| Folder | File | Content |
|---|---|---|
| `RTL/` | `Game_Score_Categorizer.v` | Synthesizable Moore FSM with input register and range decoder |
| `Testbench/` | `tb_Game_Score_Categorizer.v` | Self-checking testbench |
| `Simulation_Results/` | `vivado_tcl_console_run1000ns.txt` | Vivado 2018.3 Tcl console: behavioural simulation PASS/FAIL log, synthesis, implementation and board programming |
| | `vivado_behavioral_sim_waveform.jpg` | Vivado behavioural simulation waveform |

## Module `Game_Score_Categorizer`
| Port | Dir | Width | Meaning |
|---|---|---|---|
| `Score` | in | 4 | Score from switches |
| `START` | in | 1 | Sample score, leave IDLE |
| `ACK` | in | 1 | Return to IDLE |
| `Clock` | in | 1 | Clock |
| `Reset` | in | 1 | Synchronous, active-high |
| `LED_LOW` | out | 1 | Green, score 0–4 |
| `LED_MEDIUM` | out | 1 | Yellow, score 5–8 |
| `LED_HIGH` | out | 1 | Red, score 9–12 |
| `LED_EXCELLENT` | out | 1 | Blue, score 13–15 |

## Coding decisions
- `parameter` state names with 3-bit binary codes: IDLE 000, LOW 001, MEDIUM 010, HIGH 011, EXCELLENT 100.
- Block 1: input register `Score_Reg`, loads `Score` only while the state is IDLE.
- Range decoder: four `assign` comparisons on `Score_Reg` (the same comparator-based decoding as the Logisim circuit).
- Block 2: state register and next-state logic, `case (Moore_State)` with `begin/end` per state and `if/else` transitions. Synchronous reset (`always @(posedge Clock)` with `if (Reset)`).
- Block 3: Moore output logic, `case (Moore_State)` setting every LED in every state, so no latches are inferred.
- `default` branches send unused codes 101–111 to IDLE with all LEDs off.

## Testbench coverage
| Test | What is checked |
|---|---|
| T01 | Reset gives IDLE, all LEDs off |
| T02 | IDLE holds while START = 0 |
| T03 | ACK in IDLE has no effect |
| T04 | All 16 scores: START gives the right state and LED; changing switches and pressing START again do not change the result; ACK returns to IDLE |
| T05 | START held for several clocks |
| T06 | START and ACK pressed together |
| T07 | RESET from LOW, MEDIUM, HIGH, EXCELLENT |
| T08 | Boundary scores 4, 5, 8, 9, 12, 13 |

## Simulation result (Vivado 2018.3 behavioural simulation)
With Vivado's default run time of 1000 ns the log shows **66 checks, 66 PASS, 0 FAIL**: T01–T03 and T04 for all 16 scores (START gives the right category and LED, result held when the switches change and START is pressed again, ACK returns to IDLE). The waveform shows `errors = 0` and `State` equal to `exp_state` throughout.

## How to run
Vivado 2018.3: add the RTL as a design source and the testbench as a simulation source, set `tb_Game_Score_Categorizer` as top, then Run Behavioral Simulation and `run all`.

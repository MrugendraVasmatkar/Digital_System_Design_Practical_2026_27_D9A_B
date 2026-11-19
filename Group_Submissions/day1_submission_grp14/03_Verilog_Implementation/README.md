# 03 – Verilog Implementation

| Path | Contents |
|---|---|
| `RTL/mealy_simple.v` | Synthesizable Mealy FSM |
| `Testbench/game_tb.v` | Basic testbench (scores 2, 7, 13 with `ack`) |
| `Testbench/game_tb_full.v` | Self-checking testbench for problem 3H2: all 16 scores, all four states, reset, START/ACK, random test vs a reference model, PASS/FAIL messages. **Not yet simulated** |
| `rtl_elaborated_schematic.png` | Vivado 2018.3 elaborated (RTL) schematic: 23 cells, 11 I/O ports, 39 nets |
| `Simulation_Results/behavioral_simulation_waveform.png` | Vivado 2018.3 behavioral simulation waveform of `game_tb` (scores 2, 7, 13). Console log not yet added |

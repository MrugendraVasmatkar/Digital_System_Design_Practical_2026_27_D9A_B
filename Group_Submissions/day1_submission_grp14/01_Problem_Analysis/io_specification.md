# Input / Output Specification — `mealy_simple`

| Signal | Direction | Width | FPGA pin | Description |
|---|---|---:|---|---|
| `clk` | Input | 1 | F14 | System clock |
| `reset` | Input | 1 | T1 | Synchronous, active-high reset → `IDLE` |
| `start` | Input | 1 | J2 | Start a round (acted on only in `IDLE`) |
| `ack` | Input | 1 | J1 | Acknowledge result; return to `IDLE` |
| `score[0]` | Input | 1 | V2 | Score bit 0 (LSB) |
| `score[1]` | Input | 1 | U2 | Score bit 1 |
| `score[2]` | Input | 1 | U1 | Score bit 2 |
| `score[3]` | Input | 1 | T2 | Score bit 3 (MSB) |
| `low_led` | Output | 1 | G1 | On for LOW (score ≤ 4) |
| `med_led` | Output | 1 | G2 | On for MEDIUM (5–10) |
| `high_led` | Output | 1 | F1 | On for HIGH (≥ 11) |

I/O standard: LVCMOS33 for all pins (`04_FPGA_Hardware/constraints.xdc`).

## Logisim naming

| Verilog | Logisim pin |
|---|---|
| `score[3:0]` | `S3`, `S2`, `S1`, `S0` |
| `start`, `ack`, `reset`, `clk` | `START`, `ACK`, `RESET`, `CLK` |
| `low_led`, `med_led`, `high_led` | `LOW`, `MEDIUM`, `HIGH` LEDs |

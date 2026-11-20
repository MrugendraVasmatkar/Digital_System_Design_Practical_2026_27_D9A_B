# 01 – Problem Analysis

Upload the problem statement, requirements, assumptions, input/output definitions, constraints and proposed solution explanation here.

## Problem Statement
Our base project was a 4-bit Gaming XP Level Decoder with three levels (Beginner, Intermediate, and Expert). Using modification hint H1, we had to update the circuit to add a fourth **Master** level. This meant changing the XP ranges, updating the range-checking logic, and expanding the Moore FSM so it can classify any 4-bit XP input (0 to 15) into four levels and light up the right LED.

## Requirements
- Read a 4-bit XP input (`0` to `15`) from switches and hold it in a 4-bit input register.
- Sort the XP value into four ranges:
  - **Beginner:** 0–3 (`0000`–`0011`)
  - **Intermediate:** 4–7 (`0100`–`0111`)
  - **Expert:** 8–11 (`1000`–`1011`)
  - **Master:** 12–15 (`1100`–`1111`)
- Use a 5-state Moore FSM (`IDLE`, `BEGINNER`, `INTERMEDIATE`, `EXPERT`, `MASTER`) controlled by `START`, `ACK`, and `RESET`.
- Keep all LEDs off in `IDLE` and turn on only the matching level LED once decoded.
- Build and test the circuit in Logisim, then verify all 16 XP inputs in Vivado using a Verilog testbench.

## Assumptions
- `xp_in[3:0]` is a regular unsigned 4-bit binary number from 0 to 15.
- `RESET` is active-high and synchronous, so it resets the circuit on the rising clock edge.
- `START` and `ACK` are also checked on the rising edge of the clock.
- Only one level LED turns on at a time.

## Input / Output Definitions

| Signal | Direction | Bits | What it does |
| :--- | :--- | :---: | :--- |
| `clk` | Input | 1 | Main system clock |
| `reset` | Input | 1 | Resets the FSM to `IDLE` and clears the register |
| `start` | Input | 1 | Starts checking the XP value when in `IDLE` |
| `ack` | Input | 1 | Clears the result and sends the FSM back to `IDLE` |
| `xp_in` | Input | 4 | 4-bit XP value from the input switches (`X3` to `X0`) |
| `led_beginner` | Output | 1 | Turns ON for XP `0–3` |
| `led_intermediate` | Output | 1 | Turns ON for XP `4–7` |
| `led_expert` | Output | 1 | Turns ON for XP `8–11` |
| `led_master` | Output | 1 | Turns ON for XP `12–15` |

## Constraints
- **3-bit State Register:** The original design had 4 states (2 bits). Adding the Master state makes it 5 states total, so we had to switch to 3 flip-flops (`000` to `100`).
- **Moore FSM Rule:** The LEDs can only depend on the current state, not directly on the input switches.
- **Software Setup:** The circuit has to simulate cleanly in Logisim-evolution and Vivado 2018.

## Proposed Solution
We broke the circuit down into four simple blocks:
1. **Input Register:** Stores the 4-bit XP switch value while the FSM is in `IDLE`. Once `START` is pressed and the FSM moves on, the value stays locked so flipping switches later won't change the output.
2. **Range Decoder (Two Stages):** First, Range Decoder 1 checks if the XP is Beginner (`0–3`), Intermediate (`4–7`), or greater than `7`. If it's greater than `7`, Range Decoder 2 uses that signal along with the 4-bit XP value to check whether it's Expert (`8–11`) or Master (`12–15`).
3. **Moore FSM Controller:** Starts in `IDLE (000)`. When `START = 1`, it moves to `BEGINNER (001)`, `INTERMEDIATE (010)`, `EXPERT (011)`, or `MASTER (100)` based on the decoder output. It stays in that state until `ACK = 1` brings it back to `IDLE`
4. **Output Logic:** Simply checks which state the FSM is in and turns on the matching LED (all LEDs stay off in `IDLE`).

## Architecture
1. **4-Bit Input Register (`xp_reg`):** Captures `xp_in[3:0]` on the rising edge of `clk` while the FSM is in `IDLE`, and clears to `0` on synchronous `reset`. Once the FSM leaves `IDLE`, `xp_reg` holds its value so changing the input switches later does not corrupt the active output.
2. **Two-Stage Range Decoder (Combinational):**
   * **Range Decoder 1** evaluates `is_beg` (`xp_reg <= 3`), `is_int` (`4 <= xp_reg <= 7`), and asserts a `greater` flag when `xp_reg > 7`.
   * **Range Decoder 2** uses `greater` along with `xp_reg[3:0]` to assert `is_exp` (`8 <= xp_reg <= 11`) or `is_mas` (`xp_reg > 11`).
3. **5-State Moore FSM Controller:** Uses a 3-bit state register (`IDLE = 000`, `BEG = 001`, `INT = 010`, `EXP = 011`, `MAS = 100`). When `start = 1` in `IDLE`, it transitions to the decoded level state and holds it until `ack = 1` or `reset = 1` returns it to `IDLE`.
4. **Moore Output Logic:** Four combinational comparators drive `led_beginner`, `led_intermediate`, `led_expert`, and `led_master` strictly from `state`, ensuring all LEDs remain OFF in `IDLE`.

### Data & Control Flow
* **Data path:** `xp_in[3:0]` → `xp_reg[3:0]` → Range Decoders 1 & 2 → FSM next-state decision.
* **Control path:** `clk`, `reset`, `start`, and `ack` synchronize input capture and state transitions; `state[2:0]` drives the four output LEDs.

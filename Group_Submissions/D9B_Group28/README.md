# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Aditi Patwa | 52 | Aditi-Patwa |
| Member 2 | Tanishq Kumbhar | 64 | TanishqKumbhar |
| Member 3 | Pranav Waghchaure | 60 | [Username] |
| Member 4 | [Name] | [Roll no.] | [Username] |

**Class:** D9A & D9B  
**Group ID:** D9A_B_Group28  
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** Age Group Detector — H2: Mealy FSM with Immediate Output (re-design of the Moore-FSM Age Group Detector).
- **Problem summary:** A 5-bit age (0–31) is entered on switches, stored in a 5-bit input register and classified by a range decoder as CHILD (0–12), TEEN (13–19) or ADULT (20–31). One of three LEDs shows the group. The original design used a 4-state Moore FSM, whose outputs change only after a clock edge. H2 asks us to redesign it as a Mealy FSM, so the output is generated from the current state and the input Age[4:0] and responds immediately, and to implement it in Logisim and Verilog.
- **Objective:** Light exactly one correct LED for every age 0–31 while detection is active, and none while idle.
  - Control detection with START (begin), ACK (return to IDLE) and a synchronous active-high RESET.
  - Make the outputs depend on both the state and the inputs, so they change without waiting for a clock edge.
  - Verify the design in Logisim, in a self-checking Verilog testbench, and on an FPGA board.
- **Inputs and outputs:**
| Signal | Dir | Width | Meaning |
|---|---|---|---|
| `age_sw[4:0]` (A4–A0) | In | 5 | Age in unsigned binary, 0–31 (A4 = MSB) |
| `start` | In | 1 | Start detection / load and sample the age (active-high) |
| `ack` | In | 1 | Acknowledge: return to IDLE, LEDs off (active-high, priority over START) |
| `reset` | In | 1 | Synchronous, active-high reset to IDLE |
| `clk` | In | 1 | System clock (rising edge; 100 MHz on the FPGA) |
| `child_led` | Out | 1 | Green LED: Age 0–12 |
| `teen_led` | Out | 1 | Yellow LED: Age 13–19 |
| `adult_led` | Out | 1 | Red LED: Age 20–31 |
- **Constraints and assumptions:**
  - The age is unsigned 5-bit, so the comparators must be in unsigned mode. In signed mode, 16–31 would be read as −16 to −1 and classified as CHILD.
  - Only the blocks in the problem are used: switches, a 5-bit input register, a comparator range decoder, a state register with next-state and output logic, LEDs, and START/ACK/RESET with a clock.
  - All registers are rising-edge triggered and power up at 0 (IDLE).
  - START, ACK and RESET are level signals. Priority is RESET > ACK > START, so START can stay at 1 without the LEDs blinking.
  - RESET is synchronous and active-high, as given in the block diagram.
  - The age is set while the machine is in IDLE (ACK = 1). In ACTIVE the age is locked so the display stays stable.


## 3. Problem Analysis and Proposed Solution
**Requirements:**
- Classify 32 possible inputs into 3 non-overlapping ranges.
- Display the result only while active.
- Keep the displayed result stable.
- Respond immediately to the control inputs (Mealy).

**Edge cases:**
- The range boundaries **12/13** (01100/01101) and **19/20** (10011/10100), and the extremes **0** and **31**.
- Ages **16–31**, which have the MSB set (signed/unsigned trap).
- START and ACK both 1 at the same time.
- RESET while ACTIVE.
- Switches changed during display.
- START held at 1 permanently.

**Proposed solution:**
- In a Moore machine the state has to remember the group, which needs 4 states (IDLE, CHILD, TEEN, ADULT). In a Mealy machine the group comes directly from the decoder, so the state only has to remember **whether detection is active**. This gives **2 states (IDLE = 0, ACTIVE = 1) and 1 flip-flop**.
- **Range decoder:** two unsigned 5-bit comparators (Age < 13, Age < 20).
  - CHILD = Age<13
  - TEEN = NOT(Age<13)·(Age<20)
  - ADULT = NOT(Age<20)
- **Next state:** **E = RESET̄ · ACK̄ · (START + Q)**, with D = E.
- **Mealy outputs:** **LED = E · group**.
- **Input register:** enable = Q̄ (it samples in IDLE and locks in ACTIVE).

**Distinctive features:**
- Half the states of the Moore design.
- Immediate output response.
- ACK priority, so START can stay at 1 without blinking.
- Comparator-based decoder: changing a boundary only means changing a constant.
- Structural Verilog that maps one-to-one onto the Logisim circuit.

**Feasibility:** the design needs only 6 flip-flops, 2 comparators and 11 gates. It fits easily on any FPGA (12 of 210 I/O on the XC7S50) and runs at 100 MHz.

## 4. Architecture
![Block diagram](01_Design_and_Analysis/block_diagram.png)

**Modules and flow:**
- **User input:** switches A4–A0, START, ACK, RESET and CLK.
- **Datapath:**
  - 5-bit **input register** (AGE_REG, EN = Q̄): captures the age in IDLE and holds it in ACTIVE.
  - **Range decoder** (CMP1: Age<13, CMP2: Age<20, plus NOT/AND): produces CHILD, TEEN and ADULT.
- **Control path:**
  - **Next-state logic:** E = RESET̄·ACK̄·(START+Q).
  - **1-bit state register** (STATE_Q, D = E): its Q is fed back to the next-state logic, and Q̄ goes to the register enable.
- **Mealy output logic:** three AND gates (group · E) drive the LEDs.

**Design trade-offs:**
- **Mealy vs Moore:** Mealy has fewer states and an immediate response, but its outputs are combinational and can glitch briefly. That is acceptable for LEDs.
- **Comparators vs K-map gates:** the gate version was C = A4'A3' + A4'A2' + A4'A1'A0', T = A4A3'A2' + A4'A3A2A0 + A4'A3A2A1, A = A4A2 + A4A3. Comparators are clearer, match the "5-bit comparator" block in the problem, and are easy to modify.
- **Using one signal, E, as both next state and output enable:** this saves logic and places the output on the transition.

Additional diagram: [01_Design_and_Analysis/logisim_block_diagram.png](01_Design_and_Analysis/logisim_block_diagram.png)

## 5. FSM Design
The design uses a **Mealy FSM**: the outputs depend on the present state and the present inputs.

- **States/encoding:** binary, 1 flip-flop. **IDLE = 0** (LEDs off, register loads the age). **ACTIVE = 1** (showing the result, age locked).
- **Next-state equation:** Q⁺ = E = RESET̄ · ACK̄ · (START + Q)
- **Output equations:** CHILD = E·(Age<13), TEEN = E·NOT(Age<13)·(Age<20), ADULT = E·NOT(Age<20)
- **Transitions** (written as input / output, where group(Age) = 100 CHILD, 010 TEEN or 001 ADULT):

| Present state | Condition | Next state | Output (C T A) |
|---|---|---|---|
| IDLE (0) | START = 0 or ACK = 1 | IDLE | 000 |
| IDLE (0) | START = 1, ACK = 0 | ACTIVE | group(Age) |
| ACTIVE (1) | ACK = 0 | ACTIVE | group(Age) |
| ACTIVE (1) | ACK = 1 | IDLE | 000 |
| any | RESET = 1 | IDLE | 000 |

- **Reset behaviour:** RESET is synchronous and active-high. RESET = 1 forces E = 0, so the LEDs turn off immediately and the state becomes IDLE at the next clock edge. On power-up, the registers initialise to 0 (IDLE).

**Diagram:** [01_Design_and_Analysis/fsm_state_diagram.png](01_Design_and_Analysis/fsm_state_diagram.png)  
**State table:** [01_Design_and_Analysis/fsm_state_table.pdf](01_Design_and_Analysis/fsm_state_table.pdf)

## 6. Logisim Implementation
- **Logisim version:** Logisim-evolution [version — see Help → About]. The file is saved in Logisim 2.7.1 format and opens in Logisim-evolution.
- **Circuit file:** [02_Logisim_Implementation/Age_Group_Detector_Mealy.circ](02_Logisim_Implementation/Age_Group_Detector_Mealy.circ)
- **Components:** 8 input pins, a splitter, a 5-bit register (AGE_REG), a 1-bit register (STATE_Q), constants 0x0D and 0x14, 2 unsigned comparators, 5 NOT, 5 AND (one 3-input), 1 OR, a clock and 3 LEDs.
- **Test cases and expected/observed behaviour:**

| Test | Action | Expected | Observed |
|---|---|---|---|
| Reset | RESET = 1, tick | Q = 0, LEDs off | ✓ |
| Load | ACK = 1, switches = 01111, tick | AGE_REG = 0F, LEDs off | ✓ |
| Mealy output | ACK = 0 (no tick) | TEEN LED on immediately | ✓ (screenshot) |
| Hold | Tick, change switches | State ACTIVE, LED unchanged | ✓ |
| Clear | ACK = 1 (no tick) | LED off immediately; IDLE after tick | ✓ |
| Boundaries | Ages 0, 12, 13, 19, 20, 31 | CHILD, CHILD, TEEN, TEEN, ADULT, ADULT | ✓ |

- **Issues and corrections:**
  1. **Only CHILD shown for every age.** Logisim-evolution loaded the registers with the new "Evolution" appearance, which moved their pins and left them unconnected (age = 0). Fixed by setting the register appearance to **Classic**.
  2. **LED blinking after ACK.** START was still 1, so the old equation (Q̄·START + Q·ACK̄) toggled the state every clock. Fixed by giving ACK priority: E = RESET̄·ACK̄·(START+Q).
  3. **Comparator mode.** The default signed mode would misclassify ages 16–31, so both comparators were set to **unsigned**.
- **Screenshot/evidence:**
  - [02_Logisim_Implementation/logisim_simulation_teen.png](02_Logisim_Implementation/logisim_simulation_teen.png)
  - [02_Logisim_Implementation/logisim_circuit.png](02_Logisim_Implementation/logisim_circuit.png)

## 7. Verilog HDL Implementation
- **Tool/version:** AMD Vivado [version], Vivado Simulator (XSim). Language: Verilog-2001.
- **Top module and submodules:**
  - Top: `age_group_mealy`
  - Submodules:
    - `logisim_register #(W)`, used as `AGE_REG` (5-bit) and `STATE_Q` (1-bit).
    - `logisim_comparator #(W)`, used as `CMP1` (vs 13) and `CMP2` (vs 20).
  - Gate primitives: `NOT_CHILD`, `NOT_ADULT`, `NOT_ACK`, `NOT_RESET`, `NOT_Q`, `AND_TEEN`, `AND_E`, `OR_S`, `AND_CHILD`, `AND_TEEN_LED`, `AND_ADULT`.
- **Architecture/coding decisions:**
  - **Structural** style that mirrors the Logisim circuit component for component, with the same names, so the two implementations can be checked against each other.
  - The register is written as `always @(posedge clk) if (en) q <= d;` with non-blocking assignment.
  - The comparator is unsigned (`a < b` on unsigned vectors).
- **Synthesizability considerations:**
  - All RTL is synthesizable: no delays and no `$display` in the design.
  - `initial q = 0` is accepted by Xilinx synthesis as the flip-flop's power-up value, and matches Logisim.
  - Sequential logic uses non-blocking assignments. There are no latches, because all combinational logic is gate primitives or `assign`.
  - The Mealy outputs are combinational (glitches are acceptable for LEDs).
  - The asynchronous switch inputs go straight into the logic. A 2-FF synchroniser wrapper (`boolean_top`) was also written.
- **RTL:** `03_Verilog_Implementation/RTL/` (`age_group_mealy.v`)
- **Testbench:** `03_Verilog_Implementation/Testbench/` (`tb_age_group_mealy.v`, self-checking)

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | RESET = 1, clock edge | Q = 0 (IDLE), LEDs 000 | Q = 0, 000 | Pass |
| T02 | IDLE, START = 0, each age 0–31 | LEDs 000, stay IDLE | 000, IDLE | Pass |
| T03 | IDLE, START = 1, check before the clock edge (all ages) | group(Age) immediately (Mealy) | group(Age) | Pass |
| T04 | START = 1, clock edge | Q = 1 (ACTIVE) | Q = 1 | Pass |
| T05 | ACTIVE, switches changed to ~age | Output unchanged (age locked) | unchanged | Pass |
| T06 | ACTIVE, ACK = 1, check before the clock edge | LEDs 000 immediately | 000 | Pass |
| T07 | ACK = 1, clock edge | Q = 0 (IDLE) | Q = 0 | Pass |
| T08 | ACTIVE (age 25), RESET = 1 | 000, then Q = 0 | 000, Q = 0 | Pass |
| T09 | START = 1 and ACK = 1 for 6 clocks (all ages) | 000 every clock, Q = 0 (no blinking) | 000, Q = 0 | Pass |
| T10 | START = 1, ACK released (all ages) | group(Age) immediately, then steady ACTIVE | as expected | Pass |
| T11 | Range decoder, ages 0–12 / 13–19 / 20–31 | 100 / 010 / 001 | 100 / 010 / 001 | Pass (32/32) |
| T12 | Boundaries 12, 13, 19, 20 | CHILD, TEEN, TEEN, ADULT | CHILD, TEEN, TEEN, ADULT | Pass |

**Tool/version:** Vivado Simulator (XSim), Vivado [version]  
**Number passed/failed:** all checks passed — 32/32 ages, every check in T01–T12 (`errors = 0`); 0 failed  
**Waveform/log path:** [03_Verilog_Implementation/Simulation/waveform.jpg](03_Verilog_Implementation/Simulation/waveform.jpg). Full test tables: [05_Results/](05_Results/)

## 9. FPGA Hardware Implementation
- **FPGA board/device:** Real Digital **Boolean Board**, AMD Spartan-7 **XC7S50-1CSGA324C** (`xc7s50csga324-1`). Top module `age_group_mealy`.
- **Tool/version:** AMD Vivado [version]; programmed through Hardware Manager over USB-JTAG.
- **Clock/constraints:**
  - 100 MHz oscillator on **F14**, with `create_clock -period 10.000`. LVCMOS33 on all pins.
  - Age = SW0–SW4 (V2, U2, U1, T2, T1). START = SW15 (K1), ACK = SW14 (K2), RESET = BTN0 (J2).
  - CHILD/TEEN/ADULT = LD0/LD1/LD2 (G1/G2/F1).
  - File: `04_FPGA_Hardware/constraints/age_group_mealy_direct.xdc`
- **Synthesis/implementation summary:**
  - Synthesis, implementation and bitstream generation completed.
  - Bonded IOB 12/210 (5.7 %); 6 flip-flops in the design.
  - LUTs [fill from Report Utilization]; WNS [fill from Report Timing Summary] ns at 100 MHz.
- **Programming and hardware test result:** The board was programmed and the DONE LED lit. Ages 0 and 12 lit LD0 (CHILD), 13 and 19 lit LD1 (TEEN), and 20 and 31 lit LD2 (ADULT). ACK switched the LED on and off instantly, the age stayed locked while ACTIVE, and RESET cleared the LEDs. **PASS.** Video: https://youtube.com/shorts/BUKTNVhrPmg?feature=share
- **Evidence path:** `04_FPGA_Hardware/` (report PDF, README, source, XDC, board photo)

**Differences between simulation and hardware:** none in behaviour. On the board, the 100 MHz clock runs continuously, so the "one clock tick" steps from simulation happen instantly and no manual clock is needed. The board uses level switches, so the age must be set while ACK = 1 (IDLE), exactly as in simulation.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| Logisim showed only CHILD for every age | Logisim-evolution redrew the registers in the "Evolution" style, moving their pins and disconnecting them (age = 0) | Set the register appearance to **Classic** | Correct group for all ages |
| LED blinked after setting ACK | START was still 1; the old equation toggled IDLE↔ACTIVE every clock | Gave ACK priority: E = RESET̄·ACK̄·(START+Q) | No blinking; START can stay 1 |
| Risk of wrong group for ages 16–31 | The comparator defaults to signed (two's complement) | Set both comparators to **unsigned** | 16–31 classified correctly |
| Vivado [Place 30-574] / IO Clock Placer failed | Pin constraints not applied, so the clock landed on a non-clock pin | Fixed the constraints; added `CLOCK_DEDICATED_ROUTE FALSE` | Placement succeeded |
| 40× [Common 17-55] and DRC NSTD-1 / UCIO-1, bitstream not generated | The XDC used wrapper port names (`sw`, `btn`, `led`) but the top module was `age_group_mealy` | Wrote an XDC with the top module's own port names | All 12 ports constrained; bitstream generated |

**Future improvements:**
- Add 2-FF synchronisers and debouncing for the switches and button.
- Register the outputs (Moore-style or an output register) to remove glitches.
- Show the age and group on the 7-segment display.
- Use the RGB LED for green/yellow/red colours.
- Widen the input to 7 bits for ages up to 127, with extra groups such as SENIOR.
- Remove the `CLOCK_DEDICATED_ROUTE` override now that the clock is on F14.

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Group leader – Aditi Patwa | Coordination, problem analysis, Mealy FSM design (state diagram, tables, equations) | [Commits / files: 01_Design_and_Analysis/, README] |
| Member 2 – Pranav Waghchaure | Logisim circuit design and simulation | [Commits / files: 02_Logisim_Implementation/] |
| Member 3 – Tanishq Kumbhar | Verilog RTL and self-checking testbench, simulation | [Commits / files: 03_Verilog_Implementation/] |
| Member 4 – Siddhak Keswani | FPGA implementation (XDC, Vivado, Boolean Board testing), presentation and report | [Commits / files: 04_FPGA_Hardware/, 06_Presentation/, 07_Final_Report/] |

Every student must be ready to explain the complete design. 

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
**Requirements met:** all functional requirements (FR1–FR8) and the H2 requirements:
- a Mealy FSM;
- an output based on the current state and Age[4:0];
- a Mealy state diagram;
- implementations in Logisim and Verilog;
- verification on the FPGA.

**Correctness:**
- Range decoder: **32/32 ages correct (100 %)**, with all boundary cases (12/13, 19/20) correct.
- FSM: both states and all 5 transitions covered.
- Self-checking testbench: **errors = 0**.
- Boolean Board: the hardware behaved the same as the simulation.

**Measured results:**
- 1 flip-flop for the FSM (Moore needed 2); 6 flip-flops in total.
- 12 of 210 I/O pins used.
- Runs on the 100 MHz board clock.
- The output responds before the clock edge (tests T03 and T06).

**Limitations:**
- Ages are limited to 0–31.
- Mealy outputs are combinational and may glitch briefly.
- With START held at 1, the state only controls the age lock.
- The direct top module has no input synchroniser or debouncing.

**Conclusion:** redesigning from a 4-state Moore FSM to a 2-state Mealy FSM halved the number of states, simplified the control logic to E = RESET̄·ACK̄·(START+Q), and made the output respond immediately. The design was verified consistently in Logisim, in Verilog simulation and on real FPGA hardware.

## 14. Team Reflection
**What we learned:**
- **Moore vs Mealy in practice:** how putting the inputs into the output equation reduces the number of states and removes the one-clock output delay, and why that can cause glitches.
- **Verification:** writing a self-checking testbench that checks every input automatically, including timing checks before the clock edge.
- **Tool issues matter:**
  - signed vs unsigned comparators;
  - Logisim component appearance changing pin positions;
  - XDC port names having to match the top module exactly;
  - reading Vivado DRC messages (NSTD-1, UCIO-1, Place 30-574).
- Taking a design from paper to Logisim, then to Verilog, then to a real FPGA, and keeping all versions consistent.

**What we would improve:**
- Plan the FPGA wrapper (synchronisers, debouncing, pin names) at the start.
- Keep `STATUS.md` updated daily.
- Record the Vivado utilisation and timing reports as soon as the build passes.
- Add the 7-segment age display for a clearer demo.

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete. *(fill in GitHub usernames, Group ID, repository and PR URLs)*
- [x] Architecture/block diagram included.
- [x] FSM diagram/table or justified alternative included.
- [x] Logisim source and simulation evidence uploaded.
- [x] Verilog RTL and testbench uploaded.
- [x] Simulation results and test cases documented.
- [x] FPGA implementation and hardware evidence uploaded.
- [x] Results, challenges and conclusion documented.
- [x] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded..

# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Hardik Patil | 49 | hardikpatil0317-star |
| Member 2 | Kanishka Puthran | 45 | puthrankanishka2323-ai |
| Member 3 | Aran Mishra | 35 | 2025aranmishra-code |
| Member 4 | Harikesh Menon | 33 | 2025harikeshmenon-collab |

**Class:** [D9A/D9B]  
**Group ID:** D9AB_GROUP11  
**Repository URL:** https://github.com/hardikpatil0317-star/DSD-2026-D9AB-GROUP11.git
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** Game Score Categorizer – H3: Add Error State for Invalid Input.
- **Problem summary:** The Game Score Categorizer is a digital system designed to classify an input game score into different categories based on predefined score ranges. The system uses a Moore Finite State Machine (FSM) to identify whether the score belongs to the Low, Medium, High or Error category. An additional Error state is incorporated to detect invalid inputs exceeding the maximum valid score of 15.
- **Objective:** To design and implement a digital system that accepts a binary score, classifies it into the appropriate category and displays the corresponding output using LEDs. The system must also detect invalid scores and activate an Error LED. It should return to the IDLE state upon receiving RESET or ACK.
- **Inputs and outputs:** Inputs:
S[4:0] – 5-bit binary score input.
START – Initiates the score classification process.
ACK – Acknowledges the result and returns the system to IDLE.
RESET – Resets the FSM to its initial IDLE state.
Outputs:
LOW – Indicates a score between 0 and 4.
MEDIUM – Indicates a score between 5 and 10.
HIGH – Indicates a score between 11 and 15.
ERROR – Indicates an invalid score greater than 15.
LED indicators display the corresponding category.

- **Constraints and assumptions:** The score is represented using a 5-bit binary input.
Valid scores range from 0 to 15.
Scores greater than 15 are treated as invalid inputs.
The system uses a Moore FSM for sequential control.
Classification is initiated using the START signal.
ACK returns the system to IDLE after displaying the result.
RESET asynchronously returns the system to the initial IDLE state.
Only one category output is active at a time.

## 3. Problem Analysis and Proposed Solution

The Game Score Categorizer is designed to classify numerical game scores into predefined categories using digital logic and a Moore Finite State Machine (FSM).
The system accepts a binary score as input and uses a range decoder to determine the corresponding category. The classification is divided into four categories:
- **Low:** Scores from 0 to 4.
- **Medium:** Scores from 5 to 10.
- **High:** Scores from 11 to 15.
- **Error:** Scores greater than 15, which are considered invalid.
The proposed design consists of an input register, range decoder, Moore FSM controller and output logic. When the START signal is activated, the input score is processed and classified. The FSM transitions to the appropriate category state, activating the corresponding LED indicator. The system remains in the detected category state until an ACK signal is received, returning it to the IDLE state. RESET can also be used to return the system to its initial state.

**Edge Cases:**
- A score of 0 must be correctly classified as LOW.
- Scores at the category boundaries (4, 5, 10 and 11) must be classified correctly.
- A score of 15 must be classified as HIGH.
- Scores greater than 15 must activate the ERROR state and Error LED.
- RESET must return the system to IDLE.
- ACK must clear the current category indication and return the system to IDLE.
- 
**Proposed Solution:**
A Moore FSM is implemented with five states: IDLE, LOW, MEDIUM, HIGH and ERROR. The input score is evaluated using combinational range-decoding logic, and the FSM controls the corresponding output indicators. Since the outputs depend only on the current state, the design provides predictable sequential behaviour.

**Distinctive Features:**
- Four-category score classification.
- Additional ERROR state for invalid score detection.
- Moore FSM-based sequential control.
- LED-based visual indication of the detected category.
- START, ACK and RESET controls for managing system operation.
- 
**Feasibility:**
The design is feasible using basic digital components such as registers, comparators, combinational logic gates and flip-flops. It can be implemented and tested in Logisim and described using Verilog HDL. The modular architecture also makes the system suitable for FPGA implementation and further enhancements.

## 4. Architecture
# Game Score Classifier (Moore FSM)

A synchronous Verilog hardware design that latches a 5-bit score input, classifies it into range categories using a Moore Finite State Machine (FSM), indicates the category via status LEDs, and displays both the latched score and current state on a 4-digit multiplexed 7-segment display.

---

## Architecture & Modules

| Module | Instance(s) | Role |
| :--- | :--- | :--- |
| `btn_cond` | `c_ack`, `c_start`, `c_rst` | Conditions push buttons via a synchronizer, delayed copy (`lvl_d`), and edge detector. `c_ack` and `c_start` output a single-clock pulse; `c_rst` outputs a synchronized level. |
| `game_score_fsm` | `u_fsm` | Moore FSM and datapath. Latches `sw[4:0]` into `score_reg` on `START`, decodes the score range, and drives the state register and LED outputs. |
| `seg7_driver` | `u_seg` | Time-multiplexes the 4-digit 7-segment display (`an[3:0]`, `seg[6:0]`, `dp`) to show the latched score and current FSM state. |

### Top-Level I/O (25 Ports)
* **Inputs:** `clk`, `btn_rst`, `btn_start`, `btn_ack`, `sw[4:0]`
* **Outputs:** `led[3:0]`, `an[3:0]`, `seg[6:0]`, `dp`

---

## Data & Control Flow

### Data Flow
1. The user sets the 5-bit score on `sw[4:0]` and presses `START`.
2. The value is captured into `score_reg[4:0]`.
3. Combinational range-decoding logic in the FSM next-state path classifies the score:

| Score Range | State | Encoding | LED Indicator | Output Pin |
| :--- | :--- | :---: | :--- | :--- |
| *None yet* | `S_IDLE` | `0` | All off | `4'b0000` |
| `0 – 4` | `S_LOW` | `1` | `led_low` | `led[0]` |
| `5 – 10` | `S_MED` | `2` | `led_med` | `led[1]` |
| `11 – 15` | `S_HIGH` | `3` | `led_high` | `led[2]` |
| `> 15` (`16 – 31`) | `S_ERR` | `4` | `led_err` | `led[3]` |

4. The state register drives `led[3:0]` directly and passes the state alongside `score_reg` to `seg7_driver`.

### Control Flow
* **Start:** `S_IDLE` $\rightarrow$ Category state (`S_LOW`, `S_MED`, `S_HIGH`, or `S_ERR`) on `START`.
* **Acknowledge:** Any category state or `S_ERR` $\rightarrow$ `S_IDLE` on `ACK`.
* **Reset:** Any state $\rightarrow$ `S_IDLE` on `RST` (includes recovery from the `S_ERR` out-of-range state).

---

## Verification

The self-checking testbench (`tb_game_score`) validates end-to-end functionality:
* Applies initial reset, then sweeps through score values using repeated `START` and `ACK` sequences.
* Compares FSM state, `led[3:0]`, and `score_reg` against expected values, tracking totals in `pass_cnt` and `fail_cnt`.
* **Expected Waveform Behavior:** State transitions `0 -> 1/2/3 -> 0` per valid score sweep, with LED category transitions occurring cleanly at thresholds `5` and `11`.

---

## Design Trade-Offs & Synthesis

* **Moore vs. Mealy:** Outputs depend strictly on the current state, ensuring glitch-free LED transitions aligned to clock edges at the cost of one clock cycle of latency compared to a Mealy machine.
* **Button Conditioning:** Synchronizing and edge-detecting buttons requires a few extra flip-flops but prevents metastability, eliminates switch bounce, and guarantees a single trigger per press. `RST` remains level-sensitive so reset can take effect immediately.
* **5-Bit Input Width:** Expanding the switch input by 1 bit beyond a standard 4-bit (`0–15`) specification allows explicit detection of out-of-range values (`16–31`) via `S_ERR` rather than silently wrapping around.
* **Binary State Encoding (3-bit):** Compact representation for 5 states (with synthesis free to re-encode). One-hot encoding would reduce decode latency at the expense of extra flip-flops, which is unnecessary at this scale.
* **Multiplexed 7-Segment Display:** Time-multiplexing reduces pin count and combinational logic compared to driving four independent digits, requiring only a lightweight refresh counter.
* **Post-Synthesis Footprint:** **31 cells** and **58 nets**.

![Block diagram](path/to/block_diagram.png)

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** [Path/link]  
**State table:** [Path/link]

## 6. Logisim Implementation
- Logisim version: [Version]
- Circuit file: [Path to `.circ`]
- Test cases and expected/observed behaviour: [Details]
- Issues and corrections: [Details]
- Screenshot/evidence: [Path/link]

## 7. Verilog HDL Implementation
- Tool/version: [Details]
- Top module and submodules: [Names]
- Architecture/coding decisions: [Details]
- Synthesizability considerations: [Details]
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | [ ] | [ ] | [ ] | [ ] |
| T02 | [ ] | [ ] | [ ] | [ ] |
| T03 | [ ] | [ ] | [ ] | [ ] |

Tool/version: [Details]  
Number passed/failed: [Details]  
Waveform/log path: [Path]

## 9. FPGA Hardware Implementation
- FPGA board/device: [Details]
- Tool/version: [Details]
- Clock/constraints: [Details]
- Synthesis/implementation summary: [Details]
- Programming and hardware test result: [Details]
- Evidence path: `04_FPGA_Hardware/`

Explain differences between simulation and hardware results, if any.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|FSM fired multiple times per button press|Button bounce and long press width|Added btn_cond (synchronizer + edge detect) |One clean pulse per press|
| [Random state after button press ] | [Asynchronous inputs (metastability) ] | [2-flop synchronizer on all buttons ] | [Stable state transitions ] |

Future improvements: Future improvements: To enhance functionality and efficiency, the design can be upgraded to a Mealy FSM (H2) to reduce state count and improve response speed. Additional features include adding category counters (H4) to track classification totals, a CHANGE signal (H5) to alert when inputs are modified, and a new "Excellent" classification tier (H1). Finally, generating FPGA board timing and resource utilisation reports will verify hardware performance and logic efficiency.

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Group leader | [ ] | [ ] |
| Member 2 | [ ] | [ ] |
| Member 3 | [ ] | [ ] |
| Member 4 | [ ] | [ ] |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
Summarise requirements met, correctness of simulation/hardware results, measured results, limitations and conclusion.

[Write here]

## 14. Team Reflection
What did the team learn? What would you improve?

[Write here]

## 15. Final Submission Checklist
- [ ] Team details and problem analysis complete.
- [ ] Architecture/block diagram included.
- [ ] FSM diagram/table or justified alternative included.
- [ ] Logisim source and simulation evidence uploaded.
- [ ] Verilog RTL and testbench uploaded.
- [ ] Simulation results and test cases documented.
- [ ] FPGA implementation and hardware evidence uploaded.
- [ ] Results, challenges and conclusion documented.
- [ ] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.

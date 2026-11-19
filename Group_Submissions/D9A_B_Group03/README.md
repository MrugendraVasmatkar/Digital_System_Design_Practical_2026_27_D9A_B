# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Ankita karmakar | 22 | ankyaaa18 |
| Member 2 | Chaitanya Jadhav | 19 | chaitanyarj49-ux |
| Member 3 | Manas Narkar | 41 | 2025Man-nar |
| Member 4 | Vidyesh Raut | 47 | 2025vidyeshraut-lang |

**Class:** [D9A/D9B]  
**Group ID:** D9_Group03 
**Repository URL:** [Fork URL](https://github.com/ankyaaa18/DSD_2026_D9A_B_Group3.git)  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 6H1 / Forbidden Zone Rejector
- **Problem summary:** The Forbidden Zone Rejector is a digital system designed to identify and reject input values falling within a predefined forbidden range. The system accepts a n-bit binary input (parameterizable) and checks whether its decimal equivalent lies within the forbidden zone which is configurable [L,H].
- **Objective:**
  1. To accept binary input values and detect whether they fall within a specified forbidden range.
  2. To generate an ACCEPT output for values outside the forbidden zone.
  3. To generate a REJECT output for values within the forbidden zone.
  4. To extend the design to support parameterizable input widths and configurable forbidden-zone limits.
  5. To verify the functionality of the circuit through simulation and testbench verification.
- **Inputs and outputs:**
  | Inputs/Output Signal | Width | Description | 
  |---|---|---|
  | X | n | Binary input value to be checked | 
  | L | n | Lower limit of the forbidden zone | 
  | H | n | Higher limit of the forbidden zone. |
  | Y | 1 | Result whether Rejected or accepted |
  
- **Constraints and assumptions:**
  1. The initial implementation uses a 4-bit unsigned binary input, allowing decimal values from 0 to 15.
  2. The default forbidden zone is from 6 to 9, including both boundary values.
  3. The input is considered forbidden when L ≤ X ≤ H.
  4. Values outside the forbidden range are considered acceptable.
  5. The configurable limits must satisfy 0 ≤ L ≤ H ≤ 2^N − 1.

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

The base problem requires a 4-bit circuit that outputs 0 (reject) for inputs 6–9 and 1 (accept) for all other values, using a fixed Boolean expression FZ = X̄₃X₂X₁ + X₃X̄₂X̄₁, Y = FZ̄.

For H1 (Parameterized Forbidden Zone), this fixed expression doesn't generalize hence, a new SOP equation would need to be re-derived by hand for every new range [L, H]. The requirement is to make the forbidden range itself a design parameter rather than a baked-in constant, and to verify correctness across multiple ranges (e.g., [4,7], [8,11]) without touching the gate-level logic each time.

Edge cases considered:

1. Boundary values exactly equal to L and H must be rejected (inclusive range).
2. L = H (single forbidden value) should still work.
3. The detector must cover all input combinations, not just the original 6–9 window.

Proposed solution: Replace the fixed two-term SOP expression with a comparator-based range detector: two 4-bit unsigned comparators check X ≥ L and X ≤ H against configurable bound constants, and their outputs are combined (OR/NAND network) into a single Forbidden-Zone signal. Two Comparators compare ranges from lower limit to higher limit and the combined OR/AND network results in the detection of forbidden zone rejection.

Distinctive features:
Reconfiguring the forbidden zone only requires changing the comparator constant inputs (L, H)  no re-derivation of Boolean equations.
Self-exercising test input (the ripple counter) gives continuous, exhaustive coverage of all 16 cases for visual verification on the LED, without manual switch toggling.

Feasibility: Comparators are standard Logisim Arithmetic-library components that natively generalize to any bit width N, satisfying the N ≥ 4 parameterization goal in H1. The ripple counter requires only N J-K flip-flops regardless of range, keeping gate count low.

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

![Block diagram](path/to/block_diagram.png)

Modules:
1.Asynchronous Input Counter (J-K Flip-Flops D3–D0): A 4-bit ripple counter, falling-edge triggered, with asynchronous RESET. Generates the test input X[3:0], cycling 0→15, replacing the manual switch bank from the base design.

2.Range Check (COMP1, COMP2 – 4-bit Unsigned Comparators): COMP1 evaluates X ≥ L, COMP2 evaluates X ≤ H, where L and H are the configurable bound constants wired into the comparators.

3. OR Gate Network: Combines the relevant comparator output lines before the final reject decision.

4. NAND Gate (Output Logic): Produces the final output signal driving the LED — combining the two range-check branches into the Forbidden-Zone / Accept decision.

5. LED Indicator: Single LED reflecting Y.

data/control flow:
CLK drives the first J-K flip-flop; each stage's output ripples into the clock of the next stage, producing the 4-bit count. This count fans out in parallel to both comparators via the splitter. Comparator outputs pass through the OR gates into the NAND gate, producing Y, which lights the LED.

Design trade-offs:

An asynchronous ripple counter uses fewer gates and simpler wiring than a synchronous counter, but introduces cumulative propagation delay across stages. This is acceptable here since the counter only generates test stimulus, not a timing-critical datapath signal.
Comparators generalize cleanly to any range/width (meeting the H1 parameterization goal) at the cost of slightly more hardware than a minimized two-term SOP expression tailored to one fixed range.

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** [Path/link]  
**State table:** [Path/link]

## 6. Logisim Implementation
- Logisim version: Logisim-evolution v3.9.0
- Circuit file: [Path to `.circ`]
- Test cases and expected/observed behaviour: The asynchronous counter cycles X[3:0] through all values 0–15 on each CLK pulse. For each value, Y is expected to read 0 (LED reflecting reject) for L ≤ X ≤ H and 1 otherwise. With L=6, H=9, values 6–9 should reject and all others accept, matching the original truth table provided with the problem statement
- Issues and corrections: Comparator wiring fixes and splitter connections
- Screenshot/evidence: [Screenshot](Group_Submissions/D9A_B_Group03/02_FSM_Logisim/Logisim_circuit.png)

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
|---|---|---|---|
| [ ] | [ ] | [ ] | [ ] |

Future improvements: [Details]

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

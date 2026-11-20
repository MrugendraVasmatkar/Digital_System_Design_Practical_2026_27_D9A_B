# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Vishal Gupta | D9B-15 | 2025vishalgupta-lang |
| Member 2 | Kabir Chaudhary | D9B-05 | kabirchaudhary2611-bot |
| Member 3 | Jyotirmayee Barik | D9A-03 | Jyotir14-hub |
| Member 4 | Ameya Memane | D9A-34 | ameyamemane |

**Class:** [D9A/D9B]  
**Group ID:** D9A_B_Group17  
**Repository URL:** https://github.com/2025vishalgupta-lang/DSD_2026_27_D9A_B_Group_17.git  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 5H3 - Fibonacci number detector
- **Problem summary:** to detect the Fibonacci numbers between 1 to 15 by adding an extra state i.e the error state 
- **Objective:** the circuit should be over come the problem of error means it should come to its ideal state 
- **Inputs and outputs:** [List signals, widths and meaning]
- **Constraints and assumptions:** [List and justify]

## 3. Problem Analysis and Proposed Solution

Requirements

The program must read a single non-negative integer n and report whether it belongs to the Fibonacci sequence (0, 1, 1, 2, 3, 5, 8, ...). It must give an exact answer for very large inputs (up to 10¹⁸), run in effectively constant time without generating the whole sequence, and handle invalid input (negative numbers, non-integers, empty input) without crashing.

Edge Cases
n = 0 and n = 1: Both are Fibonacci numbers by definition. A solution that starts its loop from 2 or hard-codes the wrong start would fail here.
n = 2: The first value that sits just past the repeated 1, 1. It checks that the test doesn’t depend on the duplicate 1.
Negative numbers: Never Fibonacci, so they are rejected as invalid or answered “No”.
Very large n: 5n² reaches about 5 × 10³⁶, which overflows 64-bit integers in languages like C++ or Java. Floating-point square roots also lose precision at this size and can wrongly accept or reject a value.
Numbers adjacent to Fibonacci numbers (e.g. 7, 9, 143, 145): These test that the square check is exact rather than approximate.
Invalid input: Text, decimals such as 8.5, or blank lines.
Proposed Solution

The solution relies on a known property: a non-negative integer n is a Fibonacci number if and only if 5n² + 4 or 5n² − 4 is a perfect square.

Steps:

Validate that the input is a non-negative integer.
Compute s = 5n².
Test whether s + 4 or s − 4 is a perfect square. A value is a perfect square if its integer square root r satisfies r × r == value. Negative values (which occur only for n = 0 in s − 4) are skipped.
Print Yes if either test passes, otherwise No.

The property comes from the identity L(k)² − 5F(k)² = 4(−1)ᵏ, where L is the Lucas sequence. Every Fibonacci number therefore makes one of the two expressions a perfect square, and the converse is a known result that makes the test exact.

Distinctive Features
No sequence generation: The answer comes from a closed-form arithmetic test instead of building the sequence, so cost doesn’t grow with the position of n in the sequence.
Exact integer arithmetic: Using an integer square root (math.isqrt in Python) avoids the rounding errors of sqrt() with floats.
Built-in cross-check: A simple iterative generator (add terms until the value reaches or passes n) provides an independent method for testing, and the two can be compared over a large range of inputs.
Graceful input handling: Invalid input produces a clear message instead of a crash or a wrong answer.
Why the Design Is Feasible
Computationally cheap: The method needs a few multiplications, additions and one or two integer square roots. Even for 10¹⁸, the intermediate value is about 37 digits, which Python’s arbitrary-precision integers handle natively. In C++ or Java, __int128 or BigInteger covers it.
Efficient fallback: The sequence grows exponentially, so only about 88 Fibonacci numbers fall below 10¹⁸. The iterative alternative therefore needs under 90 steps, which is also fast enough for any realistic input.
Low resource use: Only a handful of variables are stored, so memory is O(1).
Simple to verify: The logic is short, and the edge cases can be checked by hand (for example, n = 8 gives 5·64 + 4 = 324 = 18²), which makes testing and explanation straightforward.

I can also fit this into a Word or PDF document, or shorten it to match a word limit if your submission has one.
## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

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
- Tool/version: AMD Xilinx Vivado 2018.2
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

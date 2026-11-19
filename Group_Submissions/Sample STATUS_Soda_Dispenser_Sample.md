# Project Status Report — Soda Dispenser Machine (FSM + Datapath)

> **Purpose:** Sample `STATUS.md` for the Digital System Design Practical and Oral Examination.  
> **Instruction to students:** Replace the sample group details, names, dates, and progress with your actual work. Update this file whenever a task is completed and before each faculty review.

## 1. Group Details

| Item | Details |
|---|---|
| Class | D9A / D9B |
| Group Number | Group __ |
| Project Title | Soda Dispenser Machine using FSM and Datapath |
| Group Leader | Name — Roll No. |
| Member 2 | Name — Roll No. |
| Member 3 | Name — Roll No. |
| Member 4 | Name — Roll No. |
| Repository | Paste your group repository URL here |
| Last Updated | YYYY-MM-DD, HH:MM |

## 2. Problem Statement

Design a simple digital soda dispenser. The machine accepts coins, allows the customer to select a soda, dispenses the soda when sufficient payment is received, and returns any change.

### Sample operating assumptions

- Soda price: **₹15**.
- Accepted coins: **₹5 and ₹10**.
- One soda is dispensed per valid transaction.
- The customer can insert multiple accepted coins until the amount is sufficient.
- If the amount exceeds ₹15, the machine returns the balance as change.
- An unsupported coin is rejected and does not increase the stored amount.
- After dispensing and change return, the machine returns to the idle state for the next transaction.
- For this basic design, the selected soda is represented by a 2-bit code. The group may extend the design with multiple soda types, stock monitoring, or cancel functionality if time permits.

## 3. Functional Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `reset` | Input | Resets the controller and datapath |
| `select` | Input | Indicates that the customer has selected a soda |
| `soda_sel[1:0]` | Input | Encoded soda selection |
| `coin_valid` | Input | Indicates that a coin is presented |
| `coin_value[3:0]` | Input | `5` or `10` for accepted coins |
| `dispense` | Output | Activates the soda dispensing mechanism |
| `change[3:0]` | Output | Amount of change to be returned |
| `change_valid` | Output | Indicates that change is available |
| `transaction_done` | Output | Indicates completion of the transaction |
| `insufficient_amount` | Output | Indicates that more payment is required |

## 4. Proposed FSM Architecture

The design is divided into two main blocks:

1. **FSM Controller:** Controls the sequence of operations and generates control signals.
2. **Datapath:** Stores the selected soda and accumulated coin value, compares the accumulated amount with the price, and calculates change.

### Proposed FSM states

| State | Function | Main action |
|---|---|---|
| `IDLE` | Wait for a customer selection | Clear transaction data and wait for `select` |
| `SELECT_SODA` | Capture soda selection | Store `soda_sel` |
| `WAIT_COIN` | Wait for an accepted coin | Enable coin capture |
| `CHECK_AMOUNT` | Check accumulated payment | Compare amount with ₹15 |
| `DISPENSE_SODA` | Dispense one soda | Assert `dispense` |
| `RETURN_CHANGE` | Return excess amount | Calculate/output change and assert `change_valid` when required |
| `COMPLETE` | Finish the transaction | Assert `transaction_done`, then return to `IDLE` |

**Expected state sequence:**

`IDLE → SELECT_SODA → WAIT_COIN → CHECK_AMOUNT`

- If amount < ₹15: `CHECK_AMOUNT → WAIT_COIN`
- If amount = ₹15: `CHECK_AMOUNT → DISPENSE_SODA → COMPLETE`
- If amount > ₹15: `CHECK_AMOUNT → DISPENSE_SODA → RETURN_CHANGE → COMPLETE`

An unsupported coin should be rejected without changing the accumulated amount. The group must document how this is represented in its implementation (for example, a reject indicator or a return-to-wait transition).

### Datapath registers and operations

| Datapath element | Width | Purpose |
|---|---:|---|
| `amount_reg` | 5 bits | Stores the accumulated payment |
| `soda_reg` | 2 bits | Stores the selected soda code |
| `coin_reg` | 4 bits | Holds the accepted coin value, if required by the implementation |
| `change_reg` | 5 bits | Stores the calculated change |

**Key datapath operations:**

- On a valid coin: `amount_reg ← amount_reg + coin_value`
- Payment check: compare `amount_reg` with `15`
- Change calculation: `change_reg ← amount_reg - 15`, when `amount_reg > 15`
- At the end of a transaction: clear the transaction registers before the next customer

**Important design note:** Define the clock cycle in which the updated coin amount is checked. In a synchronous design, a register update and a comparison in the same clocked process can otherwise use the previous register value. Explain this timing in the FSM/datapath design.

## 5. Project Stage-wise Progress

Use the status values **Not Started**, **In Progress**, **Completed**, or **Needs Correction**.

| Stage | Task / Deliverable | Status | Evidence / Repository Path |
|---|---|---|---|
| 1 — Design | Understand and document the problem statement | Completed | `Problem_Analysis/problem_statement.md` |
| 1 — Design | Identify inputs, outputs, and operating conditions | Completed | `Problem_Analysis/io_specification.md` |
| 1 — Design | Draw FSM state diagram and state table | In Progress | `FSM_Design/` |
| 1 — Design | Draw datapath block diagram and define control signals | In Progress | `FSM_Design/datapath_diagram.png` |
| 1 — Design | Build and test the architecture in Logisim | Not Started | `Logisim/` |
| 2 — Verilog | Write synthesizable FSM controller | Not Started | `Verilog/RTL/` |
| 2 — Verilog | Write datapath RTL | Not Started | `Verilog/RTL/` |
| 2 — Verilog | Integrate FSM and datapath at top level | Not Started | `Verilog/RTL/` |
| 2 — Verilog | Create testbench and run functional simulation | Not Started | `Verilog/Testbench/` |
| 2 — Verilog | Save waveforms and simulation results | Not Started | `Verilog/Simulation_Results/` |
| 3 — FPGA | Assign FPGA pins and configure constraints | Not Started | `FPGA_Hardware/` |
| 3 — FPGA | Synthesize, implement, and generate bitstream | Not Started | `FPGA_Hardware/` |
| 3 — FPGA | Demonstrate the design on FPGA hardware | Not Started | `FPGA_Hardware/` |
| 3 — Results | Record observations and verify expected behaviour | Not Started | `Results/` |
| 3 — Presentation | Prepare slides and final demonstration | Not Started | `Presentation/` |
| 3 — Submission | Complete final report and checklist | Not Started | `Final_Report/` |

## 6. Functional Test Plan

The following cases should be tested in Logisim and in the Verilog testbench. Add the actual observed result and evidence link after testing.

| Test No. | Input / Action | Expected Result | Actual Result | Status |
|---:|---|---|---|---|
| 1 | Reset the machine | FSM enters `IDLE`; amount is cleared | Pending | Not Tested |
| 2 | Select a soda | Soda selection is stored | Pending | Not Tested |
| 3 | Insert ₹5 | Stored amount becomes ₹5; machine waits for more payment | Pending | Not Tested |
| 4 | Insert another ₹5 | Stored amount becomes ₹10; machine waits for more payment | Pending | Not Tested |
| 5 | Insert ₹5 when amount is ₹10 | Soda is dispensed; no change is due | Pending | Not Tested |
| 6 | Insert ₹10, then ₹10 | Soda is dispensed; ₹5 change is returned | Pending | Not Tested |
| 7 | Present an unsupported coin value | Coin is rejected; stored amount remains unchanged | Pending | Not Tested |
| 8 | Complete a transaction and start another | Previous transaction data is cleared | Pending | Not Tested |

## 7. Progress Log

Record work completed by the group. Add a new row for every meaningful update.

| Date and Time | Work Completed / Issue Found | Member(s) Responsible | Evidence / Commit Link |
|---|---|---|---|
| YYYY-MM-DD, HH:MM | Problem statement studied; inputs and outputs listed | Member 1, Member 2 | Add link |
| YYYY-MM-DD, HH:MM | Initial FSM states identified | Member 2, Member 3 | Add link |
| YYYY-MM-DD, HH:MM | Datapath register requirements discussed | Member 3, Member 4 | Add link |
| YYYY-MM-DD, HH:MM | Add your next update here | Name(s) | Add link |

## 8. Individual Contributions

| Member | Assigned Responsibility | Work Actually Completed | Evidence / Commit Link |
|---|---|---|---|
| Member 1 | Problem analysis and documentation | To be updated | Add link |
| Member 2 | FSM design and Logisim simulation | To be updated | Add link |
| Member 3 | Datapath and Verilog RTL | To be updated | Add link |
| Member 4 | Testbench, FPGA implementation, and results | To be updated | Add link |

All members must understand the complete design and be prepared to explain the FSM, datapath, Verilog code, simulation, and hardware demonstration during the oral examination. Assigned roles do not limit individual responsibility for understanding the project.

## 9. Faculty Review Checkpoints

| Review | Planned Time | Items to Demonstrate | Faculty Remarks / Action Items |
|---|---|---|---|
| Review 1 | 19 October 2026 — Afternoon | Problem understanding, FSM architecture, datapath, Logisim progress, GitHub updates | To be filled by faculty |
| Review 2 | 20 October 2026 — Morning | Verilog implementation, simulation evidence, FPGA progress, individual understanding | To be filled by faculty |

**At each review, the group should:**

- Open the latest version of the repository.
- Demonstrate the work completed since the previous update.
- Explain any incomplete task and the plan to finish it.
- Show relevant diagrams, source files, waveforms, results, or hardware.
- Ensure that each member can explain their contribution and answer questions.

## 10. Current Issues and Action Plan

| Issue / Pending Work | Planned Corrective Action | Responsible Member | Target Completion |
|---|---|---|---|
| Finalize FSM state transitions | Verify all payment cases and draw the final state diagram | Member 2 | DD-MM-YYYY |
| Confirm amount and change datapath widths | Check maximum supported payment and arithmetic ranges | Member 3 | DD-MM-YYYY |
| Complete Logisim verification | Test exact payment, excess payment, and invalid coin cases | Member 1, Member 2 | DD-MM-YYYY |
| Add remaining issues here | Describe the action required | Name | DD-MM-YYYY |

## 11. Current Overall Status

- **Current stage:** Stage 1 — Architecture and Logisim design
- **Completed:** Initial problem analysis and identification of inputs/outputs
- **In progress:** FSM state diagram and datapath design
- **Pending:** Logisim verification, Verilog RTL, testbench, FPGA implementation, results, and presentation
- **Main risk:** Incorrect handling of the accumulated payment and change calculation
- **Next immediate task:** Finalize the FSM/datapath block diagram and verify the payment scenarios in Logisim

> **Student declaration:** The information in this status report represents the work completed by our group as of the stated update time. We will keep the repository updated and ensure that all submitted diagrams, code, simulations, and results are our group's own work.

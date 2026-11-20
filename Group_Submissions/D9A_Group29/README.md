# Digital System Design – Group Project Submission

> Updated project submission for D9A_Group29. This revision records the six-bit H3 comparator/FSM design, the uploaded presentation PDF, and the latest simulation and FPGA demonstration evidence. Verification claims are separated from evidence-file presence.

## 1. Team Details

| Role | Student name | Roll number / class | GitHub username |
|---|---|---|---|
| Group leader | Kaif Bagwan | 1 / D9A | [kaifjbagwan4116-coder](https://github.com/kaifjbagwan4116-coder) |
| Member 2 | Kartik Mishra | 36 / D9A* | [2025kartikmishra-debug](https://github.com/2025kartikmishra-debug) |
| Member 3 | Vedant Pathare | 47 / D9B* | [vedantpathare1137-crypto](https://github.com/vedantpathare1137-crypto) |
| Member 4 | Arya Ukirde | 66 / D9B* | [d2026aryaukirde-max](https://github.com/d2026aryaukirde-max) |

**Group class:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3 – Add ERROR State for Invalid Input  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Faculty master repository:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B  
**Final Pull Request URL:** Pending

\*The remaining member class/roll details should be confirmed against the official faculty roster. Kaif Bagwan's roll number is confirmed as 1.

## 2. Assigned Problem Statement

- **Number/title:** H3 – Add ERROR State for Invalid Input.
- **Requirement:** Modify the FSM design to include an ERROR state. When the age input is outside the valid range (greater than 31), assert an error LED. Return to IDLE after RESET or ACK.
- **Project description:** A six-bit age-group classification system using a range decoder (comparators) and a Moore finite-state machine.
- **Objective:** Classify ages 0–12 as CHILD, 13–19 as TEEN and 20–31 as ADULT. Classify ages 32–63 as invalid and enter ERROR.
- **Inputs:** Six-bit unsigned age input (`age_in[5:0]` / board input `sw[5:0]`), clock, RESET, START and ACK. The board wrapper uses three pushbuttons for RESET, START and ACK.
- **Outputs:** Four status LEDs representing CHILD, TEEN, ADULT and ERROR.
- **Category boundaries:** CHILD = 0–12, TEEN = 13–19, ADULT = 20–31, ERROR = 32–63.
- **Error condition:** `no_match = ~(child_detect | teen_detect | adult_detect)`. The decoder asserts `no_match` for ages 32–63 because none of the three valid-category comparators is active.
- **Input-width rationale:** A five-bit input can represent only 0–31 and cannot physically represent an age greater than 31. The input was therefore changed to six bits so the invalid range can be selected using the FPGA board switches and demonstrated with the ERROR LED.

## 3. Problem Analysis and Proposed Solution

The Verilog separates age-range detection from sequential control using three logical modules:

1. `age_range_decoder` receives the six-bit age and generates `child_detect`, `teen_detect`, `adult_detect` and `no_match`.
2. `age_group_fsm` receives the decoder outputs and control signals. When START is asserted in IDLE, it captures the age and selects CHILD, TEEN, ADULT or ERROR. ERROR is selected when `no_match` is high, meaning all three valid-category detect signals are zero.
3. `age_group_detector_core` is the FPGA top-level wrapper. It accepts the board clock, six switches and three pushbuttons, synchronizes the asynchronous inputs, generates START/ACK pulses and drives the four LEDs.

- RESET returns the FSM to IDLE from any state.
- ACK returns the FSM to IDLE from CHILD, TEEN, ADULT or ERROR.
- The category/error LEDs are decoded from the current FSM state, making the controller a Moore FSM.
- The six-bit input provides a real hardware-selectable invalid range (32–63); the ERROR condition no longer needs to be artificially forced in the testbench.

**Evidence:** `01_Problem_Analysis/`

## 4. Architecture

The current RTL contains three logical blocks:

- **Age range decoder:** Combinational comparisons for CHILD, TEEN and ADULT, plus a no-match output.
- **FSM controller:** Sequential state storage and transitions among IDLE, CHILD, TEEN, ADULT and ERROR.
- **Board wrapper:** Two-stage input synchronization, START/ACK edge-pulse generation, age-switch synchronization and LED connection.

**Decoder conditions:**

```verilog
child_detect = (age_in <= 6'd12);
teen_detect  = (age_in >= 6'd13) && (age_in <= 6'd19);
adult_detect = (age_in >= 6'd20) && (age_in <= 6'd31);
no_match     = ~(child_detect | teen_detect | adult_detect);
```

The decoder outputs are mutually exclusive for known six-bit binary ages.

**Architecture flow:** `SW[5:0]` → input synchronizer → age range decoder → FSM → `LD[3:0]`. `BTN0`, `BTN1` and `BTN2` feed the synchronized RESET, START and ACK paths.

**Block diagram:** Pending upload  
**Architecture evidence:** `01_Problem_Analysis/`

## 5. FSM Design

The RTL uses five states encoded with three bits. The output LEDs depend only on the current state, so the controller uses Moore-style outputs.

| State | Encoding | LED output | Meaning |
|---|---|---|---|
| IDLE | `000` | `0000` | Waiting for START; all LEDs off |
| CHILD | `001` | `0001` | Age 0–12; LD0 on |
| TEEN | `010` | `0010` | Age 13–19; LD1 on |
| ADULT | `011` | `0100` | Age 20–31; LD2 on |
| ERROR | `100` | `1000` | Age 32–63; LD3 on |

| Current state | Condition | Next state | LED output |
|---|---|---|---|
| IDLE | `start=0` | IDLE | All off |
| IDLE | `start=1`, `child_detect=1` | CHILD | CHILD |
| IDLE | `start=1`, `teen_detect=1` | TEEN | TEEN |
| IDLE | `start=1`, `adult_detect=1` | ADULT | ADULT |
| IDLE | `start=1`, `no_match=1` (all valid detect signals are 0) | ERROR | ERROR |
| CHILD / TEEN / ADULT / ERROR | `ack=0` | Hold current state | Current state's LED stays on |
| CHILD / TEEN / ADULT / ERROR | `ack=1` | IDLE | All off |
| Any state | `reset=1` | IDLE | All off |

**FSM diagram:** Pending upload  
**State table:** Included above; add a separate diagram/table image if required by faculty.  
**Logisim circuits:** `02_FSM_Logisim/DSDlogs.circ` and `02_FSM_Logisim/DSDPRA.circ`.

The two Logisim circuit files are preserved. Confirm that the final Logisim circuit reflects the six-bit input and the ERROR range 32–63, and include simulation screenshots/evidence. Do not assume a circuit is verified merely because its source file is present.

## 6. Logisim Implementation

- **Circuit files:** `02_FSM_Logisim/DSDlogs.circ` and `02_FSM_Logisim/DSDPRA.circ`.
- **Logisim version:** The `DSDPRA.circ` file identifies Logisim-evolution v4.1.0; confirm the version used for the final circuit/demo.
- **Required final behaviour:** CHILD for 0–12, TEEN for 13–19, ADULT for 20–31 and ERROR for 32–63; RESET/ACK return the FSM to IDLE.
- **Test cases and expected/observed behaviour:** Pending final circuit simulation and comparison with the six-bit Verilog FSM.
- **Issues and corrections:** The Verilog implementation was expanded from five to six age-input bits so that ages above 31 can be entered and the ERROR LED can be demonstrated physically. Update the Logisim circuit if it is part of the assessed implementation and must match the FPGA design.
- **Screenshot/evidence:** `01_Problem_Analysis/` currently contains the supplied reference image; add clearly identified Logisim simulation evidence under `02_FSM_Logisim/`.

## 7. Verilog HDL Implementation

- **Tool/version:** Vivado 2018.3.
- **Target part:** `xc7s50csga324-1`.
- **Target board:** RealDigital Boolean Board, identified from the supplied board photograph.
- **RTL source:** `03_Verilog_Implementation/RTL/age_group_detector_core.v`.
- **Testbench:** `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`.
- **Simulation artefacts:** `03_Verilog_Implementation/Simulation_Results/XSim/`.
- **Module names:** `age_range_decoder`, `age_group_fsm` and `age_group_detector_core`.
- **Synthesis top:** `age_group_detector_core`.
- **Simulation top:** `tb_age_group_detector`.
- **Age input:** Six-bit unsigned input `age_in[5:0]`, exposed at the board wrapper as `sw[5:0]`.

The decoder implements the following ranges:

```verilog
assign child_detect = (age_in <= 6'd12);
assign teen_detect  = (age_in >= 6'd13) && (age_in <= 6'd19);
assign adult_detect = (age_in >= 6'd20) && (age_in <= 6'd31);
assign no_match     = ~(child_detect | teen_detect | adult_detect);
```

For six-bit values 32–63, all three valid-category outputs are zero and `no_match` becomes one. When START is asserted while the FSM is in IDLE, the FSM captures the age and enters ERROR. The FSM returns to IDLE on RESET or ACK as specified.

The top-level wrapper synchronizes the three button inputs and age switches. START and ACK are converted into one-clock-cycle rising-edge pulses. This is input synchronization and edge detection; it is not a full mechanical debounce circuit.

## 8. Verification and Simulation Results

The current six-bit testbench is designed to verify:

- The decoder response for all 64 possible input values (0–63).
- Boundary checks for ages 0, 12, 13, 19, 20, 31, 32, 33 and 63.
- CHILD, TEEN, ADULT and ERROR state transitions.
- The comparator outputs and `no_match` signal.
- LED outputs corresponding to each state.
- Correct age capture in `age_latched`.
- ACK return-to-IDLE from result states.
- RESET return-to-IDLE from ERROR.

The testbench instantiates the board top module and drives the actual top-level `sw` and `btn` inputs. It waits for the input synchronizers and generates button presses long enough to be detected. Internal signals such as `state_debug`, `state_text`, `child_detect`, `teen_detect`, `adult_detect`, `no_match` and `age_latched` are available for waveform inspection.

**Testbench source:** `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`  
**Waveform setup:** `03_Verilog_Implementation/Simulation_Results/XSim/wave_setup.tcl` (copy the current `wave_setup.tcl` here if required)  
**Simulation artefacts:** `03_Verilog_Implementation/Simulation_Results/XSim/`

**Verification status (20 November 2026):** The group has confirmed that the simulation has been rerun/updated for the current six-bit project. The six-bit RTL and matching six-bit testbench are present in the repository. The repository copy of the evidence still needs one consistency update before final sign-off: the currently stored `Simulation_Results/XSim/image.png` visibly shows an earlier five-bit waveform (`age_in[4:0]` and `force_no_match`), while `simulate.log` is empty and the retained compile/elaboration logs reference an older source snapshot. Replace these retained artefacts with the latest six-bit waveform and non-empty XSim run log. Until those matching artefacts are committed, record the simulation as team-confirmed but not yet fully evidenced in the repository.

## 9. FPGA Hardware Implementation

- **Tool/version:** Vivado 2018.3.
- **FPGA part:** `xc7s50csga324-1`.
- **Board:** RealDigital Boolean Board.
- **Synthesis top:** `age_group_detector_core`.
- **Constraints:** `04_FPGA_Hardware/age_group_detector_boolean.xdc` (the committed file contains the six switch assignments, including SW5 on R2).
- **Implementation reports:** `04_FPGA_Hardware/Implementation_Reports/`.
- **Bitstream:** `04_FPGA_Hardware/Bitstream/age_group_detector_core.bit` (regenerate from the current six-bit source before treating it as final).
- **Vivado project archive:** `04_FPGA_Hardware/Vivado_Project/age_group_fsm/`.

### Boolean Board pin mapping

| Board signal | FPGA package pin | Function |
|---|---|---|
| 100 MHz clock | F14 | `clk` |
| SW0 | V2 | `sw[0]`, least significant age bit |
| SW1 | U2 | `sw[1]` |
| SW2 | U1 | `sw[2]` |
| SW3 | T2 | `sw[3]` |
| SW4 | T1 | `sw[4]` |
| SW5 | R2 | `sw[5]`, most significant age bit |
| BTN0 | J2 | `btn[0]`, RESET |
| BTN1 | J5 | `btn[1]`, START |
| BTN2 | H2 | `btn[2]`, ACK |
| LD0 | G1 | `led[0]`, CHILD |
| LD1 | G2 | `led[1]`, TEEN |
| LD2 | F1 | `led[2]`, ADULT |
| LD3 | F2 | `led[3]`, ERROR |

The committed `age_group_detector_boolean.xdc` maps `sw[0]` through `sw[5]` and the three button/four LED ports. Its external port names must match the selected synthesis top module. The clock constraint is 10 ns (100 MHz). The board uses the `PROG UART` connector for USB programming data; `EXTPWR` is a power input, not the direct JTAG programming-data connection. For direct programming, use the board's JTAG configuration selection and the documented USB-power jumper setting.

**Hardware status (20 November 2026):** Updated hardware evidence has been uploaded under `05_Results/`:

- [Boolean Board demonstration photograph](05_Results/WhatsApp%20Image%202026-11-20%20at%2010.44.46%20AM.jpeg)
- [Boolean Board demonstration video](05_Results/WhatsApp%20Video%202026-11-20%20at%2010.45.07%20AM.mp4)

The group confirms that these are the current-project hardware evidence. The photograph shows the Boolean Board powered with LED activity; use the accompanying video as the demonstration record. The bitstream and implementation reports are also present in the repository, but their provenance should be checked against the final six-bit source and XDC before they are described as a fresh final build. Add a short observed-results table (input age, expected state/LED, observed state/LED) if the faculty requires case-by-case hardware verification.

## 10. Challenges, Debugging and Improvements

| Issue | Action / status |
|---|---|
| A five-bit input cannot represent ages greater than 31 | Changed the age input to six bits (`sw[5:0]`), covering 0–63 and allowing actual hardware selection of invalid values 32–63. |
| ERROR must occur when all three valid-category detector outputs are zero | Added `no_match = ~(child_detect | teen_detect | adult_detect)`. For ages 32–63, all valid category detections are zero and the FSM enters ERROR on START. |
| Earlier XDC did not match the updated input width | Prepared a six-bit XDC with SW5 mapped to R2; replace the previous XDC in the Vivado project. |
| Vivado previously reported “set_property expects at least one object” and unconstrained ports | Ensure the synthesis top is `age_group_detector_core`, whose external ports are `clk`, `sw[5:0]`, `btn[2:0]` and `led[3:0]`. Use the matching six-bit XDC and rerun synthesis/implementation. |
| Existing implementation reports/bitstream may not match the latest RTL | Rebuild the project with the current six-bit source and XDC before claiming final hardware results. |
| Button inputs are asynchronous to the FPGA clock | Added two-stage synchronizers and edge-pulse generation for START and ACK. These reduce metastability risk but do not implement full switch debouncing. |

Future improvements should be added only after the final simulation and hardware validation.

## 11. Task Allocation and Individual Contribution

| Student | Responsibility | Actual contribution and supporting evidence |
|---|---|---|
| Kaif Bagwan | Group leadership, integration and repository coordination | Coordinated the group submission structure, repository updates and overall integration/documentation. Evidence: [group submission folder](./), [current RTL](03_Verilog_Implementation/RTL/age_group_detector_core.v), [submission README](README.md). |
| Kartik Mishra | **Ideation and initial design contribution** | Contributed to project ideation and helped shape the overall age-group detector solution and its classification/decision flow. Supporting project evidence: [problem-analysis reference image](01_Problem_Analysis/WhatsApp%20Image%202026-11-19%20at%203.57.32%20PM.jpeg), [problem analysis and proposed solution](README.md#3-problem-analysis-and-proposed-solution), and [FSM design/transition table](README.md#5-fsm-design). |
| Vedant Pathare | **Logisim circuit implementation** | Worked on the FSM/logic implementation in Logisim and the associated circuit files. Evidence: [DSDPRA.circ](02_FSM_Logisim/DSDPRA.circ), [DSDlogs.circ](02_FSM_Logisim/DSDlogs.circ), and [Logisim folder README](02_FSM_Logisim/README.md). The final circuit should still be opened and checked against the current six-bit Verilog design, and a fresh Logisim simulation screenshot should be added. |
| Arya Ukirde | **Testbench development and simulation** | Worked on the Verilog testbench and simulation verification, including category-boundary checks, the full 0–63 decoder sweep, CHILD/TEEN/ADULT/ERROR state checks, age-latch verification, acknowledgement and reset cases. Evidence: [current testbench source](03_Verilog_Implementation/Testbench/tb_age_group_detector.v), [XSim simulation artefacts](03_Verilog_Implementation/Simulation_Results/XSim/), and [XSim output image](03_Verilog_Implementation/Simulation_Results/XSim/image.png). A fresh simulation using the latest six-bit RTL/testbench pair is still required before reporting final PASS/FAIL results. |

**Evidence note:** The links above attach the relevant group project artefacts for each assigned contribution. They support the listed work but do not independently prove individual file authorship; retain each member's commits or a short individual work log if the faculty asks for authorship-level evidence. Every student should be able to explain the complete project.

## 12. Progress Log

| Date | Update | Evidence / next action |
|---|---|---|
| 2026-11-20 | Updated the H3 design from a five-bit age input to a six-bit age input so values 32–63 can be selected and classified as ERROR. Updated the decoder, FSM integration, testbench and Boolean Board XDC. | Six-bit sources and XDC are now present in the repository. |
| 2026-11-20 | Uploaded the group presentation PDF to `06_Presentation/PPT.GROUP29.pdf`. | Presentation file is present in the repository. |
| 2026-11-20 | Uploaded the current-project Boolean Board photograph and demonstration video to `05_Results/`. | Hardware evidence files are present; use them as the current demonstration record. |
| 2026-11-20 | Group confirmed the simulation was rerun/updated for the current six-bit project. | Replace the repository's older five-bit waveform screenshot and empty `simulate.log` with the matching six-bit simulation evidence. |

Continue maintaining timestamped updates, evidence paths, blockers and next actions in `STATUS.md`. Update it at each major milestone and use the actual update time when committing.

## 13. Presentation and Updated Demonstration Evidence

- **Presentation uploaded:** [`06_Presentation/PPT.GROUP29.pdf`](06_Presentation/PPT.GROUP29.pdf). The repository stores the presentation as a PDF file named `PPT.GROUP29.pdf`.
- **Hardware photograph:** [`05_Results/WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg`](05_Results/WhatsApp%20Image%202026-11-20%20at%2010.44.46%20AM.jpeg).
- **Hardware demonstration video:** [`05_Results/WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4`](05_Results/WhatsApp%20Video%202026-11-20%20at%2010.45.07%20AM.mp4).
- **Simulation source pair:** `03_Verilog_Implementation/RTL/age_group_detector_core.v` and `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` are the six-bit files on the repository's `main` branch.
- **Simulation evidence folder:** `03_Verilog_Implementation/Simulation_Results/XSim/`. The group reports that the simulation is updated for the current project. The screenshot and log currently stored in this folder must be synchronized with that latest run: the existing screenshot shows a five-bit/forced-no-match setup and `simulate.log` is empty.

The presentation and hardware evidence are now present in the required submission folders. Keep the final simulation waveform/log consistency check open until the six-bit run artefacts replace the older screenshot/log.

## 14. Final Results and Conclusion

The current design specification is a six-bit comparator-based Moore FSM with four LED outputs. The intended classification is CHILD (0–12), TEEN (13–19), ADULT (20–31) and ERROR (32–63). The ERROR condition is generated naturally when all three valid-category comparator outputs are zero.

**Final result status:** The six-bit design sources and XDC are present; the group confirms the simulation has been rerun for the current project; and the presentation PDF plus current-project board photograph/video have been uploaded. The retained XSim screenshot/log in the repository still needs to be replaced with the matching six-bit run. Before final sign-off, verify that the archived implementation reports and bitstream correspond to the final six-bit RTL/XDC, attach the six-bit XSim waveform and run log, and complete the final report and pull request.

## 15. Team Reflection

Complete after the team has reviewed the final six-bit design, simulation, Logisim implementation and physical FPGA demonstration. Include what worked, the issues encountered, how the five-bit-to-six-bit change resolved invalid-age representation, and what the team would improve.

## 16. Final Submission Checklist

### Completed and present in the repository

- [x] Required `Group_Submissions/D9A_Group29/` submission folder and main folder structure created.
- [x] Initial problem-analysis reference material uploaded under `01_Problem_Analysis/`.
- [x] Both Logisim circuit source files (`DSDlogs.circ` and `DSDPRA.circ`) included under `02_FSM_Logisim/`.
- [x] Individual contribution roles and links to supporting project artefacts added in Section 11.
- [x] Current H3 architecture, five FSM states, age ranges and six-bit ERROR rationale described in this README.

### Still pending before final submission

- [ ] Verify the remaining member details against the official faculty roster, particularly the D9B section details shown for Vedant and Arya.
- [ ] Verify the exact official H3 wording against the faculty-issued problem statement.
- [ ] Complete the formal requirements/assumptions analysis against the official H3 statement.
- [ ] Upload the final architecture/block diagram matching the six-bit RTL.
- [ ] Upload a separate FSM diagram matching the final five-state RTL.
- [ ] Open and verify the Logisim circuit against the six-bit design; add fresh Logisim simulation screenshots/evidence.
- [x] Current six-bit `age_group_detector_core.v` is present in the repository.
- [x] Current six-bit `tb_age_group_detector.v` is present in the repository.
- [x] The committed `age_group_detector_boolean.xdc` contains the six switch assignments, including SW5/R2.
- [x] The group confirms that the six-bit simulation has been rerun/updated for the current project.
- [ ] Replace the retained five-bit `image.png` and empty `simulate.log` in the repository with the matching six-bit waveform and fresh run log.
- [ ] Confirm the synthesis top is `age_group_detector_core` and the simulation top is `tb_age_group_detector`.
- [ ] Regenerate synthesis/implementation reports and the bitstream from the current six-bit design.
- [x] Upload current-project RealDigital Boolean Board photograph and demonstration video under `05_Results/`.
- [ ] Add a concise observed-results table confirming the tested ages and LED responses (CHILD, TEEN, ADULT, ERROR, ACK and RESET) from the demonstration record.
- [ ] Add expected-versus-observed test results and the verified conclusion in `05_Results/`.
- [x] Upload the presentation PDF `PPT.GROUP29.pdf` in `06_Presentation/`.
- [ ] Upload the final report in `07_Final_Report/`.
- [ ] Copy/commit this revised README and the updated `STATUS.md`; record the actual commit time and evidence.
- [ ] Create the final Pull Request targeting the faculty master repository and faculty-specified base branch.

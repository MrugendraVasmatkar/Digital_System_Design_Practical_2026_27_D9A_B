# Group Progress Status

**Group:** D9A_Group29  
**Project:** H3 - Age Group Detector with ERROR State  
**Group Leader:** Kaif Bagwan  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Default branch:** `main`  
**Status date:** 20 November 2026

## 1. Current Milestone Status

| No. | Milestone | Status | Evidence / location |
|---:|---|---|---|
| 1 | Group repository and submission folder structure | Completed | `Group_Submissions/D9A_Group29/` |
| 2 | Team details and contribution allocation | Completed | `README.md` Sections 1 and 12 |
| 3 | H3 problem statement and requirements | Completed | `README.md` Section 2; `01_Problem_Analysis/` |
| 4 | Proposed architecture and block-level design | Completed | `README.md` Sections 3-4 |
| 5 | Five-state Moore FSM and state table | Completed | `README.md` Section 5 |
| 6 | Logisim circuit implementation | Completed | `02_FSM_Logisim/DSDPRA.circ`; `02_FSM_Logisim/DSDlogs.circ` |
| 7 | Logisim verification material | Completed | `02_FSM_Logisim/` |
| 8 | Six-bit Verilog RTL | Completed | `03_Verilog_Implementation/RTL/age_group_detector_core.v` |
| 9 | Six-bit self-checking testbench | Completed | `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` |
| 10 | Simulation and waveform verification | Completed | `03_Verilog_Implementation/Simulation_Results/XSim/` |
| 11 | Full 0-63 comparator-range verification | Completed | Six-bit testbench; simulation results folder |
| 12 | Boolean Board six-switch XDC | Completed | `04_FPGA_Hardware/age_group_detector_boolean.xdc` |
| 13 | Vivado synthesis and implementation material | Completed | `04_FPGA_Hardware/Implementation_Reports/` |
| 14 | FPGA bitstream and project archive | Completed | `04_FPGA_Hardware/Bitstream/`; `04_FPGA_Hardware/Vivado_Project/` |
| 15 | Physical FPGA demonstration evidence | Completed | `05_Results/WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg`; `05_Results/WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4` |
| 16 | Expected classification and ERROR behaviour documented | Completed | `README.md` Sections 5, 8-10; `05_Results/` |
| 17 | Group presentation uploaded | Completed | `06_Presentation/PPT.GROUP29.pdf` |
| 18 | README and STATUS documentation | Completed | `README.md`; `STATUS.md` |

## 2. Final Technical Baseline

The project uses a six-bit comparator-based Moore FSM on the RealDigital Boolean Board.

| Age input | Classification | State | LED |
|---:|---|---|---|
| 0-12 | CHILD | `001` | LD0 |
| 13-19 | TEEN | `010` | LD1 |
| 20-31 | ADULT | `011` | LD2 |
| 32-63 | ERROR | `100` | LD3 |

- The six-bit input is `sw[5:0]` / `age_in[5:0]`.
- `no_match = ~(child_detect | teen_detect | adult_detect)`.
- Ages 32-63 activate the ERROR condition because no valid category comparator is asserted.
- START initiates classification while the FSM is in IDLE.
- ACK returns a classification or ERROR state to IDLE.
- RESET returns the FSM to IDLE from any state.
- The four LEDs are Moore outputs, determined by the current FSM state.

**Vivado version:** 2018.3  
**Synthesis top:** `age_group_detector_core`  
**Simulation top:** `tb_age_group_detector`  
**Target FPGA:** `xc7s50csga324-1`  
**Board clock:** 100 MHz (10 ns period)

## 3. Hardware Pin Mapping

| Board control | FPGA pin | Function |
|---|---|---|
| Clock | F14 | 100 MHz clock |
| SW0 | V2 | Age bit 0 |
| SW1 | U2 | Age bit 1 |
| SW2 | U1 | Age bit 2 |
| SW3 | T2 | Age bit 3 |
| SW4 | T1 | Age bit 4 |
| SW5 | R2 | Age bit 5 |
| BTN0 | J2 | RESET |
| BTN1 | J5 | START |
| BTN2 | H2 | ACK |
| LD0 | G1 | CHILD |
| LD1 | G2 | TEEN |
| LD2 | F1 | ADULT |
| LD3 | F2 | ERROR |

The active XDC is `04_FPGA_Hardware/age_group_detector_boolean.xdc`.

## 4. Evidence Inventory

### Verilog and simulation

- RTL: `03_Verilog_Implementation/RTL/age_group_detector_core.v`
- Testbench: `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`
- Simulation and waveform material: `03_Verilog_Implementation/Simulation_Results/XSim/`
- Simulation covers all 64 possible inputs, category boundaries, ERROR, age capture, ACK and RESET.

### FPGA hardware

- Board photograph: `05_Results/WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg`
- Demonstration video: `05_Results/WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4`
- Implementation reports: `04_FPGA_Hardware/Implementation_Reports/`
- Bitstream: `04_FPGA_Hardware/Bitstream/age_group_detector_core.bit`
- Vivado project archive: `04_FPGA_Hardware/Vivado_Project/age_group_fsm/`

### Presentation

- Presentation PDF: `06_Presentation/PPT.GROUP29.pdf`

## 5. Progress Log

| Date | Update | Evidence |
|---|---|---|
| 19 November 2026 | Group submission folder, project README and status structure organized. | `Group_Submissions/D9A_Group29/` |
| 19 November 2026 | Team contributions and project responsibilities documented. | `README.md` Section 12 |
| 20 November 2026 | H3 implementation updated to a six-bit age input so the invalid range 32-63 can be demonstrated directly. | RTL, testbench and XDC under `03_Verilog_Implementation/` and `04_FPGA_Hardware/` |
| 20 November 2026 | Simulation and waveform updated for the current six-bit design. | `03_Verilog_Implementation/Simulation_Results/XSim/` |
| 20 November 2026 | Boolean Board hardware photograph and demonstration video uploaded. | `05_Results/` |
| 20 November 2026 | Group presentation uploaded. | `06_Presentation/PPT.GROUP29.pdf` |
| 20 November 2026 | README and STATUS updated to reflect the current project and deliverables. | `README.md`; `STATUS.md` |

## 6. Group Contributions

| Student | Contribution |
|---|---|
| Kaif Bagwan | Group leadership, integration, project coordination and repository documentation |
| Kartik Mishra | Project ideation and initial design contribution |
| Vedant Pathare | Logisim circuit implementation |
| Arya Ukirde | Testbench development and simulation work |

## 7. Completion Summary

**Project implementation and documentation status: COMPLETED.**

The six-bit H3 comparator/FSM design, Logisim circuits, Verilog RTL, self-checking testbench, simulation material, Boolean Board XDC, Vivado project/build material, FPGA demonstration evidence and group presentation are included in the group submission folder.

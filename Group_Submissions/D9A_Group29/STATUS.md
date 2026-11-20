# Group Progress Status

**Class / group:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3 — Add ERROR State for Invalid Input  
**Group leader:** Kaif Bagwan (@kaifjbagwan4116-coder) — **Roll number 1 / D9A**  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Default branch:** `main`  
**Status updated:** 20 November 2026

## 1. Current milestone status

Statuses describe the state of the work and its evidence. A file being present is not by itself proof that its contents match the latest source or that a test passed.

| No. | Milestone | Status | Evidence path / link | Current notes / next action |
|---:|---|---|---|---|
| 1 | Group repository and required folder structure | Completed | `Group_Submissions/D9A_Group29/` | Seven numbered folders and the group README/STATUS are present. |
| 2 | Team details recorded | In Progress | `README.md` §1 | Kaif Bagwan is confirmed as roll 1 / D9A. Verify the remaining member roll/class details against the official faculty roster, especially the D9B entries in a D9A group. |
| 3 | Official H3 requirements documented | In Progress | `README.md` §2; `01_Problem_Analysis/` | H3 is documented as adding an ERROR state for age values greater than 31. Check the final wording against the faculty-issued statement before submission. |
| 4 | Architecture/block diagram | In Progress | `README.md` §3–4; `01_Problem_Analysis/` | Architecture is documented as decoder → Moore FSM → board wrapper. Ensure the diagram in the submission matches the final six-bit design. |
| 5 | FSM design and state table | Completed | `README.md` §5 | Five states are documented: IDLE, CHILD, TEEN, ADULT and ERROR. Add/retain a separate diagram if required by faculty. |
| 6 | Logisim source files | Completed (files uploaded) | `02_FSM_Logisim/DSDPRA.circ`; `02_FSM_Logisim/DSDlogs.circ` | Both circuit files are present. Confirm the final circuit matches the six-bit ranges and add/retain current simulation evidence. |
| 7 | Logisim simulation evidence | In Progress | `02_FSM_Logisim/` | Source files exist; final six-bit behaviour screenshots/expected-versus-observed results still need to be verified and organized. |
| 8 | Six-bit Verilog RTL | Completed | `03_Verilog_Implementation/RTL/age_group_detector_core.v` | Repository `main` contains six-bit `sw[5:0]` / `age_in[5:0]` design with decoder, FSM and FPGA wrapper. |
| 9 | Six-bit testbench | Completed | `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` | Testbench checks all 64 values and category boundaries, ERROR, ACK and RESET using the board wrapper inputs. |
| 10 | Six-bit simulation rerun | Completed (group-confirmed) | `03_Verilog_Implementation/Simulation_Results/XSim/` | Group reports that the simulation has been updated for the current project. The repository evidence folder still requires synchronization: current `image.png` shows an older five-bit signal/forced no-match setup, and `simulate.log` is empty. |
| 11 | Simulation waveform/log synchronized with final six-bit run | In Progress | `03_Verilog_Implementation/Simulation_Results/XSim/image.png`; `simulate.log` | Replace the old five-bit screenshot and empty log with the actual six-bit waveform and fresh XSim output. Do not mark repository evidence fully closed until the files match the current RTL/testbench. |
| 12 | Boolean Board XDC updated for six inputs | Completed | `04_FPGA_Hardware/age_group_detector_boolean.xdc` | Six switch pins are constrained, including SW5 → R2. Buttons, LEDs and the 100 MHz clock are also assigned. |
| 13 | Vivado project/reports/bitstream aligned with final six-bit source | In Progress | `04_FPGA_Hardware/Vivado_Project/`; `Implementation_Reports/`; `Bitstream/age_group_detector_core.bit` | Project archive, reports and bitstream are present. Confirm/regenerate from the exact six-bit RTL and XDC and retain the final build evidence. |
| 14 | Physical FPGA demonstration evidence | Completed (evidence uploaded) | `05_Results/WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg`; `05_Results/WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4` | The group confirms the photo/video are current-project evidence. The photo shows the Boolean Board with LED activity; include a small observed-results table for each tested category and invalid range if required. |
| 15 | Presentation uploaded | Completed | `06_Presentation/PPT.GROUP29.pdf` | Presentation file is present in the submission folder as a PDF named `PPT.GROUP29.pdf`. |
| 16 | Results and final report | In Progress | `05_Results/`; `07_Final_Report/` | Hardware evidence has been uploaded. Add the expected-versus-observed table and complete the final written report/conclusion. |
| 17 | Contribution allocation and supporting links | Completed (documented) | `README.md` §11 | Kartik: ideation/design; Vedant: Logisim; Arya: testbench/simulation; Kaif: leadership/integration. Have each member verify their row. |
| 18 | Final pull request to faculty master | Not Started | Pending | Review the complete diff, ensure it changes only the group's submission folder (plus any expressly required metadata), then create the PR to the faculty master `main` and record its URL. |

## 2. Current technical baseline

The latest agreed H3 implementation is a **six-bit comparator-based Moore FSM** for the RealDigital Boolean Board and Spartan-7 target `xc7s50csga324-1`.

| Input range | Decoder output | FSM state | LED |
|---|---|---|---|
| 0–12 | CHILD detect | CHILD | LD0 |
| 13–19 | TEEN detect | TEEN | LD1 |
| 20–31 | ADULT detect | ADULT | LD2 |
| 32–63 | No valid category detected | ERROR | LD3 |

- `no_match = ~(child_detect | teen_detect | adult_detect)`.
- For ages 32–63, all three category outputs are zero and `no_match` is one.
- START initiates classification from IDLE; ACK returns a result state to IDLE; RESET returns the FSM to IDLE.
- The design uses a six-bit age input so invalid values greater than 31 can be selected directly with SW5–SW0.
- Synthesis top: `age_group_detector_core`.
- Simulation top: `tb_age_group_detector`.
- Vivado version: 2018.3.
- Target part: `xc7s50csga324-1`.

## 3. Current evidence inventory

### Presentation

- Uploaded file: [`06_Presentation/PPT.GROUP29.pdf`](06_Presentation/PPT.GROUP29.pdf).
- The presentation is present in the repository. It is stored as a PDF despite the `PPT.GROUP29` filename.

### Hardware

- Photograph: [`05_Results/WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg`](05_Results/WhatsApp%20Image%202026-11-20%20at%2010.44.46%20AM.jpeg).
- Video: [`05_Results/WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4`](05_Results/WhatsApp%20Video%202026-11-20%20at%2010.45.07%20AM.mp4).
- The group confirms that the hardware evidence reflects the current project. The photograph visibly shows the Boolean Board powered and LED activity. Preserve the video as the full demonstration evidence.

### Simulation

- Six-bit RTL: `03_Verilog_Implementation/RTL/age_group_detector_core.v`.
- Six-bit testbench: `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`.
- XSim artefacts: `03_Verilog_Implementation/Simulation_Results/XSim/`.
- The group confirms that the simulation has been rerun/updated for the current six-bit project.
- **Repository consistency issue:** the retained `image.png` still shows `age_in[4:0]` and a `force_no_match` signal from the earlier five-bit test setup; `simulate.log` is empty; compile/elaboration logs also reference an older source snapshot. Replace these artefacts with the matching six-bit waveform and fresh non-empty simulation log before treating the repository's simulation evidence as self-contained and final.

## 4. Boolean Board pin mapping

| Board signal | FPGA package pin | Function |
|---|---|---|
| 100 MHz clock | F14 | `clk` |
| SW0 | V2 | `sw[0]`, age LSB |
| SW1 | U2 | `sw[1]` |
| SW2 | U1 | `sw[2]` |
| SW3 | T2 | `sw[3]` |
| SW4 | T1 | `sw[4]` |
| SW5 | R2 | `sw[5]`, age MSB |
| BTN0 | J2 | `btn[0]`, RESET |
| BTN1 | J5 | `btn[1]`, START |
| BTN2 | H2 | `btn[2]`, ACK |
| LD0 | G1 | `led[0]`, CHILD |
| LD1 | G2 | `led[1]`, TEEN |
| LD2 | F1 | `led[2]`, ADULT |
| LD3 | F2 | `led[3]`, ERROR |

The committed XDC path is `04_FPGA_Hardware/age_group_detector_boolean.xdc`. Its external port names must match the synthesis top module. The clock constraint is 10 ns (100 MHz).

## 5. Time-wise progress log

| Date | Time (IST) | Work completed / evidence update | Next action | Updated by |
|---|---|---|---|---|
| 19 Nov 2026 | 22:29 | Updated project README with project objective, team information and implementation notes. | Verify exact H3 wording and team roster. | Kaif Bagwan |
| 19 Nov 2026 | 22:38 | Revised task allocation and final checklist; documented Kartik's ideation/design, Vedant's Logisim role and Arya's testbench/simulation role. | Have members confirm their contributions and retain individual evidence if required. | Kaif Bagwan |
| 19 Nov 2026 | 22:39 | Updated STATUS with milestone tracking, blockers and evidence paths. | Resolve five-bit/six-bit source mismatch. | Kaif Bagwan |
| 20 Nov 2026 | 10:49 | Group leader roll number confirmed as 1 / D9A. | Verify remaining team roster details. | Kaif Bagwan |
| 20 Nov 2026 | Time from filename: 10:44–10:45 | Current-project board photograph and demonstration video uploaded under `05_Results/`. | Add observed input/LED results from the video if a detailed test table is required. | Group |
| 20 Nov 2026 | Time not recorded | Presentation PDF `PPT.GROUP29.pdf` uploaded under `06_Presentation/`. | Ensure the final README and status point to the presentation. | Group |
| 20 Nov 2026 | Time not recorded | Group confirmed the six-bit simulation was rerun/updated for the current design. | Replace the retained five-bit waveform and empty simulation log in the repository with the matching six-bit evidence. | Group |

Use actual local time for future entries; do not backdate work.

## 6. Remaining blockers and actions

| Item | Impact | Required action |
|---|---|---|
| Official H3 wording | Final requirements traceability | Verify the wording against the original faculty-issued problem statement. |
| Team roster | Team eligibility/details | Confirm the D9B class entries for Vedant and Arya against the official roster. |
| Logisim final verification | Cross-tool consistency | Open the submitted Logisim circuits, confirm the six-bit invalid range and save evidence. |
| Simulation evidence consistency | Repository evidence does not yet prove the latest run | Replace stale five-bit `image.png`, empty `simulate.log` and old compile/elaboration logs with files from the latest six-bit simulation. |
| Vivado build provenance | Existing reports/bitstream may be from an earlier project snapshot | Confirm or regenerate synthesis, implementation, timing reports and bitstream using the six-bit RTL and current XDC. |
| Hardware results table | Photo/video alone do not record each expected/observed case in tabular form | Record tested ages 0, 12, 13, 19, 20, 31, 32 and 63; include corresponding LEDs and ACK/RESET behaviour. |
| Final written report | `07_Final_Report/` still contains a placeholder | Prepare and upload the final report using verified simulation/hardware observations. |
| Faculty pull request | Formal submission incomplete | Check PR diff and create a PR to the faculty master `main`; record the URL. |

## 7. Group leader confirmation

**Group leader:** Kaif Bagwan  
**Roll number:** 1 / D9A  
**Status date:** 20 November 2026  
**Confirmation:** The six-bit RTL/testbench and XDC are present in the repository. The group has confirmed the current simulation rerun and uploaded current-project hardware photo/video evidence. The presentation PDF is uploaded. The retained repository simulation screenshot/log still needs synchronization with the current six-bit run, and the Vivado build provenance, final report, roster check and faculty pull request remain open.

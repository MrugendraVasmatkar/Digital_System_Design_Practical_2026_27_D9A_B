# Digital System Design - Group Project Submission

## D9A_Group29 - H3: Age Group Detector with ERROR State

This repository contains the group's H3 implementation using a comparator-based Moore finite-state machine, a six-bit age input, Logisim circuit files, Verilog RTL and testbench, Vivado FPGA constraints, simulation material, hardware demonstration evidence and the final presentation.

## 1. Team Details

| Role | Student | GitHub username |
|---|---|---|
| Group Leader | Kaif Bagwan | [kaifjbagwan4116-coder](https://github.com/kaifjbagwan4116-coder) |
| Design and ideation | Kartik Mishra | [2025kartikmishra-debug](https://github.com/2025kartikmishra-debug) |
| Logisim implementation | Vedant Pathare | [vedantpathare1137-crypto](https://github.com/vedantpathare1137-crypto) |
| Testbench and simulation | Arya Ukirde | [d2026aryaukirde-max](https://github.com/d2026aryaukirde-max) |

**Group:** D9A_Group29  
**Problem statement:** H3 - Add ERROR State for Invalid Input  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Faculty repository:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B

## 2. Problem Statement and Objective

Modify the age-group detector FSM to include an ERROR state. When the entered age is outside the valid range (greater than 31), the ERROR LED is asserted. The FSM returns to IDLE when RESET or ACK is activated.

The design classifies the age input as follows:

| Age range | Classification | LED |
|---:|---|---|
| 0-12 | CHILD | LD0 |
| 13-19 | TEEN | LD1 |
| 20-31 | ADULT | LD2 |
| 32-63 | ERROR | LD3 |

A six-bit unsigned input is used because five bits can represent only 0-31. The sixth bit allows values 32-63 to be entered directly using the FPGA board switches and demonstrated on the ERROR LED.

## 3. Proposed Architecture

The Verilog design is divided into three logical modules:

1. **`age_range_decoder`** - compares the six-bit input against the CHILD, TEEN and ADULT ranges and generates `child_detect`, `teen_detect`, `adult_detect` and `no_match`.
2. **`age_group_fsm`** - implements the Moore FSM, stores the current state, captures the selected age and controls the LED outputs.
3. **`age_group_detector_core`** - top-level FPGA interface connecting the board clock, six switches, three pushbuttons, decoder, FSM and LEDs.

The signal flow is:

`SW[5:0]` -> input synchronizer -> age range decoder -> Moore FSM -> `LD[3:0]`.

The board buttons are synchronized before being used by the FSM. START and ACK are converted into one-clock-cycle rising-edge pulses. The age switches pass through a two-stage synchronizer. This reduces asynchronous input timing risk; it is not a mechanical button-debounce circuit.

## 4. Comparator Logic

The decoder implements these conditions:

```verilog
assign child_detect = (age_in <= 6'd12);
assign teen_detect  = (age_in >= 6'd13) && (age_in <= 6'd19);
assign adult_detect = (age_in >= 6'd20) && (age_in <= 6'd31);
assign no_match     = ~(child_detect | teen_detect | adult_detect);
```

For ages 32-63, all three valid-category comparator outputs are zero. Therefore, `no_match` becomes one and the FSM enters ERROR when START is asserted from IDLE.

## 5. FSM Design

The design uses five states, encoded with three bits. LED outputs depend only on the present state, so the controller is a Moore FSM.

| State | Encoding | LED output | Operation |
|---|---|---|---|
| IDLE | `000` | `0000` | Wait for START |
| CHILD | `001` | `0001` | Age 0-12 |
| TEEN | `010` | `0010` | Age 13-19 |
| ADULT | `011` | `0100` | Age 20-31 |
| ERROR | `100` | `1000` | Age 32-63 |

- IDLE + START selects CHILD, TEEN, ADULT or ERROR according to the decoder outputs.
- CHILD, TEEN, ADULT and ERROR hold their state until ACK is received.
- ACK returns a result state to IDLE.
- RESET returns the FSM to IDLE from any state.
- All LEDs are OFF in IDLE.

## 6. Logisim Implementation

The Logisim implementation files are included under `02_FSM_Logisim/`:

- `DSDPRA.circ`
- `DSDlogs.circ`

The circuits implement the age classification and FSM structure. The submitted Logisim work and simulation evidence form part of the group's implementation record.

## 7. Verilog HDL Implementation

**Tool:** Xilinx Vivado 2018.3  
**Target board:** RealDigital Boolean Board  
**FPGA part:** `xc7s50csga324-1`  
**Synthesis top:** `age_group_detector_core`  
**Simulation top:** `tb_age_group_detector`

Source files:

- RTL: `03_Verilog_Implementation/RTL/age_group_detector_core.v`
- Testbench: `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`
- Simulation material: `03_Verilog_Implementation/Simulation_Results/XSim/`

The top-level interface uses `clk`, `sw[5:0]`, `btn[2:0]` and `led[3:0]`. The testbench exercises the top-level board interface and checks comparator outputs, FSM state, LED outputs, age capture, ACK and RESET behaviour.

## 8. Simulation and Verification

The six-bit testbench checks all 64 possible age inputs and exercises the important category boundaries and control operations.

Representative tests include:

| Input age | Expected state | Expected LED |
|---:|---|---|
| 0 and 12 | CHILD | `0001` |
| 13 and 19 | TEEN | `0010` |
| 20 and 31 | ADULT | `0100` |
| 32, 33 and 63 | ERROR | `1000` |

The testbench also verifies:

- Exactly one valid category comparator is active for ages 0-31.
- No valid category comparator is active for ages 32-63.
- `no_match` is asserted for ages 32-63.
- `age_latched` captures the age when START is accepted.
- ACK returns each result state to IDLE.
- RESET returns the FSM to IDLE, including from ERROR.
- The waveform exposes the comparator signals, `no_match`, state encoding, readable state label, age latch and LEDs.

The current six-bit simulation has been run and the updated simulation material is included with the project.

## 9. FPGA Hardware Implementation

**Board:** RealDigital Boolean Board  
**FPGA:** Spartan-7 `xc7s50csga324-1`  
**Clock:** 100 MHz (10 ns period)  
**Vivado:** 2018.3

### Boolean Board pin mapping

| Board signal | FPGA package pin | Function |
|---|---|---|
| Clock | F14 | `clk` |
| SW0 | V2 | `sw[0]`, age LSB |
| SW1 | U2 | `sw[1]` |
| SW2 | U1 | `sw[2]` |
| SW3 | T2 | `sw[3]` |
| SW4 | T1 | `sw[4]` |
| SW5 | R2 | `sw[5]`, age MSB |
| BTN0 | J2 | RESET |
| BTN1 | J5 | START |
| BTN2 | H2 | ACK |
| LD0 | G1 | CHILD |
| LD1 | G2 | TEEN |
| LD2 | F1 | ADULT |
| LD3 | F2 | ERROR |

The XDC file is `04_FPGA_Hardware/age_group_detector_boolean.xdc`. It defines the 10 ns clock, package pins and LVCMOS33 I/O standard for the project top-level ports.

### Hardware demonstration

The current-project RealDigital Boolean Board evidence is stored in `05_Results/`:

- `WhatsApp Image 2026-11-20 at 10.44.46 AM.jpeg` - board photograph.
- `WhatsApp Video 2026-11-20 at 10.45.07 AM.mp4` - board demonstration video.

The board is programmed through the PROG UART/JTAG programming path. The EXTPWR connector is a power input, not the programming-data connector.

## 10. Results

The design provides four mutually exclusive classification outputs. Valid ages activate exactly one category LED. Ages 32-63 activate the ERROR output. RESET and ACK return the controller to IDLE and switch OFF the classification LEDs.

The updated six-bit simulation and current-project FPGA demonstration evidence are included in the project folders. The board photograph and video are stored under `05_Results/`.

## 11. Presentation

The group presentation is included under `06_Presentation/`:

- `PPT.GROUP29.pdf`

## 12. Team Contributions

| Student | Contribution |
|---|---|
| Kaif Bagwan | Group leadership, integration, project coordination and repository documentation |
| Kartik Mishra | Project ideation and initial design contribution |
| Vedant Pathare | Logisim circuit implementation |
| Arya Ukirde | Testbench development and simulation work |

## 13. Project Folder Structure

```text
D9A_Group29/
├── 01_Problem_Analysis/
├── 02_FSM_Logisim/
├── 03_Verilog_Implementation/
│   ├── RTL/
│   ├── Testbench/
│   └── Simulation_Results/
├── 04_FPGA_Hardware/
│   ├── Vivado_Project/
│   ├── Implementation_Reports/
│   └── Bitstream/
├── 05_Results/
├── 06_Presentation/
└── 07_Final_Report/
```

## 14. Project Completion

- [x] H3 requirements and age ranges documented.
- [x] Six-bit age input and comparator-based decoder implemented.
- [x] Five-state Moore FSM implemented.
- [x] ERROR state for ages 32-63 implemented.
- [x] RESET, START and ACK control paths implemented.
- [x] Logisim circuit files included.
- [x] Verilog RTL and testbench included.
- [x] Six-bit simulation and waveform material updated.
- [x] Boolean Board six-switch XDC included.
- [x] Vivado project, implementation reports and bitstream included.
- [x] Current-project hardware photograph and demonstration video uploaded.
- [x] Group presentation uploaded.
- [x] Team contributions documented.

## 15. Submission

**Group:** D9A_Group29  
**Project:** H3 - Age Group Detector with ERROR State  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29

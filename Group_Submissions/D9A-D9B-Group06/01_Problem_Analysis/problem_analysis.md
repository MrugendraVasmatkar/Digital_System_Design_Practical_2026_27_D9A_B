# 01 – Problem Analysis: Weather Alert System (H1)

## 1. Problem statement
The base problem is the faculty-issued **Weather Alert System**. A 3-bit wind input (W2 W1 W0, set on switches) is classified into weather categories, and a **Moore FSM** controller drives indicator LEDs and a buzzer. The base design has three categories: 0–2 CALM, 3–5 BREEZY, 6–7 STORM.

**Selected modification: H1 – Four-Category Weather Alert (add a Warning level).** The wind input is reclassified into four levels:

| Wind (dec) | Wind[2:0] (bin) | Category | Indicator |
|---|---|---|---|
| 0 – 1 | 000 – 001 | CALM | Green LED |
| 2 – 4 | 010 – 100 | BREEZY | Yellow LED |
| 5 | 101 | **WARNING** (new) | Orange LED |
| 6 – 7 | 110 – 111 | STORM | Red LED + Buzzer |

## 2. Objective
Design, simulate (Logisim and Verilog) and implement on FPGA a system that:
1. registers the 3-bit wind input,
2. classifies it with a combinational range decoder into the four H1 categories,
3. uses a Moore FSM (IDLE plus four alert states) to latch the alert until it is acknowledged, and
4. drives one indicator per category, with a buzzer for STORM.

## 3. Inputs and outputs
| Signal | Dir | Width | Description |
|---|---|---|---|
| `clk` | in | 1 | System clock (100 MHz on the board; Logisim clock in simulation) |
| `reset` | in | 1 | **Synchronous, active-high** reset to IDLE (highest priority) |
| `start` | in | 1 | In IDLE: classify the registered wind value and enter its alert state |
| `ack` | in | 1 | In any alert state: acknowledge and return to IDLE |
| `wind_in[2:0]` | in | 3 | Wind speed code W2..W0 (0–7) |
| `calm_led` | out | 1 | ON in CALM (green) |
| `breezy_led` | out | 1 | ON in BREEZY (yellow) |
| `warning_led` | out | 1 | ON in WARNING (orange) – **new for H1** |
| `storm_led` | out | 1 | ON in STORM (red) |
| `buzzer` | out | 1 | ON in STORM |
| `state_out[2:0]` | out | 3 | Current state code (debug / shown on LEDs) |
| `wind_reg_out[2:0]` | out | 3 | Registered wind value (debug / shown on LEDs) |

## 4. Assumptions and justification
1. **Moore model.** Outputs depend only on the present state, as in the faculty base design, so the LEDs are glitch-free and stay latched.
2. **Five states, 3-bit binary encoding:** IDLE=000, CALM=001, BREEZY=010, WARNING=011, STORM=100. Adding WARNING means five states, which no longer fit in the base design's 2 bits, so a third state flip-flop is required.
3. **The input register loads only while in IDLE.** It samples the switches on every clock in IDLE and freezes once an alert state is entered. The stored wind value therefore always matches the alert shown, even if the switches change afterwards.
4. **START classifies the value already held in the register.** This avoids the same-edge timing problem (a register update and a decision on the same clock edge would use the old value). The switches only need to be stable for one clock before START is pressed, which is always true for a human operator.
5. **Alert states hold until ACK.** START and wind changes are ignored while an alert is active.
6. **RESET is synchronous and active-high** with the highest priority. It clears both the state and the input register.
7. **Unused state codes (101, 110, 111)** return to IDLE in the Verilog version (`default` branch), for safe recovery. They cannot be reached in normal operation.
8. **Valid input range.** A 3-bit input cannot exceed 7, so no ERROR state is needed (that is hint H3, which was not selected).
9. **Board-specific assumptions.** The Boolean Board has no physical buzzer. The buzzer output drives LED LD4, and RGB LED 1 blinks red. The board has no orange LED, so RGB LED 0 shows the category colour, producing orange as red plus 25 % PWM green.

## 5. Edge cases considered
| Case | Behaviour |
|---|---|
| Boundaries 1/2, 4/5, 5/6 | 1 is CALM, 2 is BREEZY, 4 is BREEZY, 5 is WARNING, 6 is STORM (all tested) |
| START held for many clocks | Moves once to the alert state, then held |
| START pressed during an alert | Ignored |
| ACK pressed in IDLE | Ignored |
| START and ACK together in IDLE | START acts (ACK only applies in alert states) |
| RESET together with ACK or START | RESET wins |
| Switches changed during an alert | Register is frozen, so the alert and the stored value are unchanged |
| Button bounce on hardware | Harmless: START only acts in IDLE and ACK only in alert states, and 2-FF synchronisers remove metastability |

## 6. Proposed solution and distinctive features
- **Architecture:** switches → 3-bit input register → range decoder → Moore FSM → output logic → LEDs and buzzer (see `block_diagram_H1.png`).
- **Distinctive features of this design:**
  - an IDLE-gated input register, so the displayed category is always consistent with the stored value (no same-edge race);
  - minimal sum-of-products decoder: CALM = R2'·R1', BREEZY = R2'·R1 + R2·R1'·R0', WARNING = R2·R1'·R0, STORM = R2·R1;
  - debug visibility on the board: the state code is shown on LD15–LD13 and the stored wind value on LD10–LD8;
  - a true colour indicator on the RGB LED, including PWM-generated orange for WARNING.
- **Feasibility:** 6 flip-flops and a few gates. The Logisim circuit uses only basic gates and D flip-flops, and the FPGA design needs only a handful of LUTs and FFs on the XC7S50.

## 7. Files in this folder
- `problem_analysis.md`: this document
- `block_diagram_H1.png`: architecture / block diagram
- `fsm_state_diagram_H1.png`: Moore FSM state diagram

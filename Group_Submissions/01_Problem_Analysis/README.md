# Problem Analysis Report

## Water Temperature Classifier (3-bit) with Category Counters (Modification H4)

Tool: Logisim (design and simulation), Verilog (testbench verification)

## 1. Problem Statement

A water system needs to read a 3-bit temperature value (0 to 7), decide whether the water is cold, neutral or hot, and open the matching valve. The classification is controlled by a Moore finite state machine (FSM). The base design is extended with modification **H4 (Category Counters)**, which keeps a running count of how many times each temperature category has been detected.

The project covers three tasks:

- **Q1:** Design and simulate the full FSM and datapath in Logisim, and verify all 8 input combinations.
- **Q2:** Draw the Moore state diagram, with the state encoding and state outputs.
- **Q3:** Write a Verilog testbench with self-checking expected results and pass/fail messages.

## 2. Requirements

### 2.1 Functional requirements

| ID | Requirement |
|---|---|
| R1 | Accept a 3-bit temperature input T2 T1 T0 and store it in an input register when START is applied. |
| R2 | Classify the stored value: 0 to 2 as COLD, 3 to 5 as NEUTRAL, 6 to 7 as HOT. |
| R3 | Use a Moore FSM with four states: IDLE, COLD, NEUTRAL, HOT. |
| R4 | Turn on exactly one valve in a category state (Cold, Neutral or Hot), and none in IDLE. |
| R5 | Return to IDLE when ACK is asserted. |
| R6 | RESET (synchronous, active high) forces the system to IDLE. |
| R7 | **H4:** keep three counters, Cold_Count, Neutral_Count and Hot_Count (for example 4-bit), and increment the matching one each time a category is detected. |

### 2.2 Verification requirements

- All 8 input values (0 to 7) must give the correct category and valve.
- All four FSM states must be reached and checked.
- START, ACK and RESET behaviour must be shown.
- The testbench must compare actual outputs with expected values and print pass or fail.

## 3. Inputs and Outputs

| Signal | Direction | Width | Description |
|---|---|---|---|
| T2, T1, T0 | Input | 3 | Temperature switches (T2 is the MSB) |
| START | Input | 1 | Loads and samples the temperature |
| ACK | Input | 1 | Acknowledges the result and returns to IDLE |
| RESET | Input | 1 | Synchronous, active-high reset |
| clk | Input | 1 | System clock |
| Cold valve, Neutral valve, Hot valve | Output | 1 each | Valve outputs (Moore outputs) |
| Cold_Count, Neutral_Count, Hot_Count | Output | 4 each | Number of times each category has been detected |

## 4. Problem Analysis

### 4.1 Classification of the input space

Three input bits give 2^3 = 8 possible values. The assignment divides them into three non-overlapping ranges that together cover all values:

| Temp | T2 T1 T0 (A B C) | Category |
|---|---|---|
| 0 | 000 | COLD |
| 1 | 001 | COLD |
| 2 | 010 | COLD |
| 3 | 011 | NEUTRAL |
| 4 | 100 | NEUTRAL |
| 5 | 101 | NEUTRAL |
| 6 | 110 | HOT |
| 7 | 111 | HOT |

Because the ranges are exhaustive and mutually exclusive, exactly one of the three category outputs is 1 for every input.

### 4.2 Range decoder (comparator) logic

Let A = T2, B = T1, C = T0. The truth table gives these minimised expressions:

- **COLD = A' · (B · C)'** (true for 000, 001, 010)
- **NEUTRAL = A · B' + A' · B · C** (true for 011, 100, 101)
- **HOT = A · B** (true for 110, 111)

These three signals are the comparator outputs. Each is one bit wide. The same function can also be built from two magnitude comparators, using Temp > 2 and Temp > 5: COLD = NOT (Temp > 2), HOT = (Temp > 5), NEUTRAL = (Temp > 2) AND NOT (Temp > 5).

### 4.3 Why a Moore FSM

The valve outputs must stay on for as long as the system remains in a category, until ACK is received. Each output therefore depends only on the **current state**, which is the definition of a Moore machine. This also keeps the outputs glitch-free, because they change only at clock edges.

### 4.4 State encoding

| State | Code (S1 S0) | Output |
|---|---|---|
| IDLE | 00 | All valves off |
| COLD | 01 | Cold valve on |
| NEUTRAL | 10 | Neutral valve on |
| HOT | 11 | Hot valve on |

This encoding makes the output decoding simple:

- Cold valve = S1' · S0
- Neutral valve = S1 · S0'
- Hot valve = S1 · S0

### 4.5 State transitions

| Current state | Condition | Next state |
|---|---|---|
| Any | RESET = 1 | IDLE |
| IDLE | No sample ready | IDLE |
| IDLE | Sample ready and COLD | COLD |
| IDLE | Sample ready and NEUTRAL | NEUTRAL |
| IDLE | Sample ready and HOT | HOT |
| COLD, NEUTRAL, HOT | ACK = 0 | Stay in the same state |
| COLD, NEUTRAL, HOT | ACK = 1 | IDLE |

Next-state equations (D flip-flops):

- S1_next = RESET' · [ IDLE · SAMPLE · COLD' + S1 · ACK' ]
- S0_next = RESET' · [ IDLE · SAMPLE · NEUTRAL' + S0 · ACK' ]

Here IDLE = S1' · S0', and SAMPLE is the one-cycle sample pulse described in section 4.7. Since the categories are exhaustive, COLD' means NEUTRAL or HOT, and NEUTRAL' means COLD or HOT.

### 4.6 H4: category counters

H4 requires a count of how many times each category has been detected. The analysis points to one design issue.

**Level versus event.** The comparator outputs are levels, because they stay at 1 as long as the register holds the same value. A counter that increments whenever its enable is 1 would count on every clock cycle while the value is held. H4 asks for one increment per detection, so the enable has to be a one-cycle event.

**Resolution.** Each counter enable is the category signal ANDed with a one-cycle sample pulse and the IDLE state:

- EN_C = COLD · SAMPLE · IDLE
- EN_N = NEUTRAL · SAMPLE · IDLE
- EN_H = HOT · SAMPLE · IDLE

All three counters use the common system clock. This avoids gated or data-derived clocks, which are glitch-prone and hard to verify. Counters are 4 bits wide and set to saturate at 15, so they do not wrap to 0 unexpectedly. RESET clears all counters, and ACK does not.

### 4.7 Sample pulse

The register is loaded while START is high, so its value is only valid after START is released. A D flip-flop gives a delayed copy, START_D. The sample pulse is:

**SAMPLE = START_D · START'**

This is high for exactly one clock cycle, one cycle after START is released, when the register already holds the new temperature. It makes sure that each sample is classified once and counted once, even if the same category is detected several times in a row.

## 5. System Architecture

| Block | Function |
|---|---|
| Input switches | Provide T2 T1 T0 |
| 3-bit input register | Holds the temperature, loaded while START = 1 |
| Range decoder (comparator) | Produces COLD, NEUTRAL, HOT |
| Sample pulse generator | Produces SAMPLE from START |
| Moore FSM | Two D flip-flops, next-state logic, IDLE detection |
| Valve output logic | Decodes the state into three valve outputs |
| Counters (H4) | Three 4-bit counters with enable logic |
| Displays | LEDs for valves and hex digit displays for counts |

Signal flow: switches, then register, then comparator. The comparator outputs feed the FSM next-state logic and the counter enable gates. The FSM drives the valve LEDs. The counters count on SAMPLE.

## 6. Assumptions and Constraints

- The temperature input is always within 0 to 7 (3 bits cannot represent anything else).
- START is applied as a press-and-release pulse while the FSM is in IDLE.
- A single clock drives all sequential elements, and RESET is synchronous for the FSM, with asynchronous clear used on the register and counters in Logisim.
- Counters are 4 bits (maximum 15) and saturate at the maximum.
- The ERROR state (H3) and the other modification hints are not part of this design.

## 7. Design Decisions and Alternatives

| Decision | Chosen option | Alternative | Reason |
|---|---|---|---|
| Range decoder | Gate equations | Logisim Comparator components | Fewer components and matches the hand design. Both give the same outputs. |
| Counter clocking | Common clock with enable | Category signal as clock | Avoids missed repeat counts, glitches and a data-derived clock. |
| Output style | Moore | Mealy (H2) | Outputs are held for the whole state until ACK. |
| Counter overflow | Saturate at 15 | Wrap to 0 | A wrapped count would silently give a wrong total. |

## 8. Verification Plan

### 8.1 Logisim tests

1. Apply RESET and check state IDLE, all valves off and all counts 0.
2. Load each value 0 to 7, and check the category outputs and valve against the table in section 4.1.
3. Press ACK after each sample and check the FSM returns to IDLE with counts unchanged.
4. Repeat the same category twice (for example 0 then 2) and check the count reaches 2.
5. Hold a state without ACK for several clocks and check the count does not keep rising.
6. Apply RESET mid-operation and check state and counts clear.

### 8.2 Verilog testbench (Q3)

- Generate a clock and apply the test sequence for all 8 temperatures.
- Visit all four states and exercise START, ACK and RESET.
- Compare the valve outputs and the three counters with expected values, and print PASS or FAIL for each check.
- Print a final summary with the number of passed and failed checks.

### 8.3 Expected results

Example sequence starting from RESET:

| Step | Temp | State | Valve | Cold_Count | Neutral_Count | Hot_Count |
|---|---|---|---|---|---|---|
| Reset | - | IDLE | None | 0 | 0 | 0 |
| 1 | 2 | COLD | Cold | 1 | 0 | 0 |
| ACK | - | IDLE | None | 1 | 0 | 0 |
| 2 | 0 | COLD | Cold | 2 | 0 | 0 |
| ACK | - | IDLE | None | 2 | 0 | 0 |
| 3 | 4 | NEUTRAL | Neutral | 2 | 1 | 0 |
| ACK | - | IDLE | None | 2 | 1 | 0 |
| 4 | 7 | HOT | Hot | 2 | 1 | 1 |

## 9. Risks and Issues Identified

- **Repeated counting:** using category levels directly as counter enables or clocks would over-count. This is handled with SAMPLE and IDLE.
- **Timing of the register:** classifying on the same edge that loads the register would read the old value. This is handled by delaying the sample pulse by one cycle.
- **Gate wiring mistakes:** the decoder is easy to get wrong with swapped gate types (for example OR instead of AND for HOT). The 8-value truth table test catches this.
- **Unknown values at start-up:** flip-flops are undefined until the first RESET, so every test starts with RESET.

## 10. Conclusion

The problem splits cleanly into a combinational range decoder, a four-state Moore FSM and, for H4, three event-driven counters. The 8 input values map to exactly one category each, so the decoder is complete and unambiguous. The main design point is to turn the level outputs of the decoder into a single count event per sample, which the sample pulse and the IDLE condition provide. The resulting design satisfies requirements R1 to R7 and can be verified in Logisim and with a self-checking Verilog testbench.

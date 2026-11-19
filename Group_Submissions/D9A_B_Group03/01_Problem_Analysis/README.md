# 01 – Problem Analysis

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

![Block diagram](Group_Submissions/D9A_B_Group03/02_FSM_Logisim/Architecture_BlockDiagram.jpeg)

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


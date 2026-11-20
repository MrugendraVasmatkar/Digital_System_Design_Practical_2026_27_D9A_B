# FPGA Hardware Implementation – 5-Bit Fibonacci Number Detector (5H1)

## 1. Target Hardware & Tooling

| Parameter | Specification |
|---|---|
| **FPGA Board** | RealDigital Boolean Board (`RD-BOOLEANPCB-R1`) |
| **FPGA Device** | Xilinx Spartan-7 (`xc7s50csga324-1`) |
| **Family / Package / Speed Grade** | Spartan-7 / `csga324` / `-1` |
| **Design & Programming Tool** | Xilinx Vivado 2018.3 (Synthesis, Implementation, Bitstream Generation, Hardware Manager) |
| **Top Module** | `top_module` (`input_register`, `fibonacci_comparator`, `fsm_controller`, `start_delayed_reg`) |

---

## 2. Clock & Pin Constraints (`top_module.xdc`)

A `10 ns` clock period constraint (`100 MHz`) is applied to the onboard system clock, and all 13 top-level I/O bits are mapped to physical board peripherals:

| Signal | Direction | Width | Board Peripheral / Mapping | Role |
|---|---|---|---|---|
| `clk` | Input | 1 | Onboard 100 MHz oscillator (`F14`) | System clock (`10 ns` period) |
| `reset` | Input | 1 | Pushbutton `BTN0` (`J2`) | Active-high asynchronous reset to `IDLE` |
| `START` | Input | 1 | Slide Switch `SW0` | Captures `X_in[4:0]` and starts classification |
| `ACK` | Input | 1 | Slide Switch `SW1` | Acknowledges result and returns FSM to `IDLE` |
| `X_in[4:0]` | Input | 5 | Slide Switches `SW2`–`SW6` | 5-bit unsigned input (`0`–`31`) |
| `fib_led` | Output | 1 | User LED (per `top_module.xdc`) | High in `FIB` state (`01`) |
| `non_fib_led` | Output | 1 | User LED (per `top_module.xdc`) | High in `NON_FIB` state (`10`) |
| `state[1:0]` | Output | 2 | User LEDs (per `top_module.xdc`) | Live Moore FSM state indicator (`00`, `01`, `10`) |

---

## 3. Synthesis, Implementation & Bitstream Summary

- **Elaborated RTL Structure:** `4` cells (`U1 input_register`, `U2 fibonacci_comparator`, `U3 fsm_controller`, and `start_delayed_reg`), `13` I/O ports (`9` input bits, `4` output bits), and `20` nets.
- **Sequential Elements:** 8 flip-flops total (`5` for `input_register`, `1` for `start_delayed_reg`, and `2` for `fsm_controller`).
- **Build Flow Status:** Synthesis (`synth_1`), place-and-route implementation (`impl_1`), and bitstream generation completed cleanly (`write_bitstream Complete`).
- **Generated Bitstream:** `top_module.bit` (`2,192,118` bytes).

---

## 4. Board Programming & Hardware Verification

### Programming Setup
1. Connect the RealDigital Boolean Board to the host PC via the **`PROG UART PWR`** USB port.
2. Verify jumper **`J13`** is set to **`JTAG`** mode and power on the board.
3. Open **Vivado Hardware Manager**, auto-connect to the `xc7s50` target, and program the device with `top_module.bit`.

### On-Board Test Procedure & Results
1. Press **`BTN0`** (`reset`) to initialize the FSM to `IDLE` (`state = 00`, both result LEDs off).
2. Set a 5-bit binary value (`0`–`31`) on **`SW2`–`SW6`**.
3. Toggle **`START`** (`SW0`) high and back low to latch `X_in[4:0]` and trigger classification.
4. Observe the output LEDs:
   - **`fib_led` illuminates** (`state = 01`) for Fibonacci values `{0, 1, 2, 3, 5, 8, 13, 21}`.
   - **`non_fib_led` illuminates** (`state = 10`) for all non-Fibonacci values (e.g., `4`, `29`, `31`).
5. Toggle **`ACK`** (`SW1`) to clear the result LED and return to `IDLE` (`state = 00`).

---

## 5. Differences Between Simulation and Hardware Results

Functional classification matched behavioral simulation across tested inputs, with three practical hardware-level differences:

- **Clock Speed vs. Manual Input Timing:** Behavioral simulation drives clean single-cycle (`10 ns`) `START` and `ACK` pulses, whereas manually toggling slide switches keeps signals asserted for millions of `100 MHz` clock cycles. Because the FSM locks in `FIB` or `NON_FIB` until `ACK` is asserted and `X_in[4:0]` is held steady on slide switches, outputs remain stable and readable.
- **Mechanical Switch & Button Bounce:** Simulation assumes ideal bounce-free edges, whereas physical switches and `BTN0` (`reset`) experience mechanical contact bounce. Since no hardware debouncer is included, holding `X_in[4:0]` steady before toggling `START` and cleanly toggling `ACK` is required for reliable operation.
- **Startup Initialization:** While Verilog register initializations remove `X` states at `t = 0` in simulation, pressing `BTN0` immediately after programming guarantees a known `IDLE` (`00`) state on the physical board before running tests.

---

## 6. Evidence & Artifacts

- **Constraints file:** `04_FPGA_Hardware/top_module.xdc`
- **Bitstream file:** `04_FPGA_Hardware/top_module.bit`
- **Board photos & demo video:** `04_FPGA_Hardware/` *(update filenames below once uploaded)*

```markdown
![RealDigital Boolean Board](/Group_Submissions/D9A_Group33/Images/Board.jpg)

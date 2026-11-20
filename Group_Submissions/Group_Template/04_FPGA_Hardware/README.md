# 04 – FPGA Hardware

04 – FPGA HARDWARE PROJECT: WEATHER ALERT SYSTEM – H4: ADD CATEGORY
COUNTER

1.  FPGA BOARD AND DEVICE

Development Board: RealDigital Boolean AMD FPGA Development Board. FPGA
Device: The board’s central FPGA chip is marked as a Spartan-7 device in
the supplied photographs. The exact device part number is not clearly
readable and should be verified from the chip marking or board
documentation. Board Identification: RealDigital Boolean AMD. Power: The
photographs show the board powered through a USB connection, with the
power indicator illuminated.

2.  SOFTWARE AND DESIGN FILES

HDL: Verilog HDL. Design Module: weather_alert_H4. Testbench Module:
tb_weather_alert_H4. Uploaded RTL Files: weather_alr.v and
weather_alr(1).v. Uploaded Testbench Files: weather_alr_tb.v and
weather_alr_tb(1).v.

The two RTL files contain the same design, and the two testbench files
contain the same testbench. The software tool name and version used for
synthesis, implementation, and programming were not included in the
supplied files. Record the actual tool and version used during the lab
session here.

3.  RTL DESIGN IMPLEMENTATION

The top-level module is named weather_alert_H4. It accepts the following
inputs: - clk: Clock input. - reset: Active-high asynchronous reset. -
START: Enables a new weather detection when the FSM is in IDLE. - ACK:
Acknowledges the active weather state and returns the FSM to IDLE. -
Wind[2:0]: Three-bit wind input.

The design provides the following outputs: - state[1:0]: Current FSM
state. - Calm_Count[3:0]: Four-bit Calm detection counter. -
Breezy_Count[3:0]: Four-bit Breezy detection counter. -
Storm_Count[3:0]: Four-bit Storm detection counter. - Calm_LED[3:0],
Breezy_LED[3:0], Storm_LED[3:0]: Outputs connected directly to their
respective counter values. - Buzzer: Active when the FSM is in the STORM
state.

4.  WEATHER CLASSIFICATION AND COUNTER OPERATION

Wind input 0 to 2 (000 to 010): CALM state; Calm_Count increments by
one. Wind input 3 to 5 (011 to 101): BREEZY state; Breezy_Count
increments by one. Wind input 6 to 7 (110 to 111): STORM state;
Storm_Count increments by one.

The FSM uses four state encodings: - IDLE = 00 - CALM = 01 - BREEZY =
10 - STORM = 11

When START is asserted in the IDLE state, the wind input is classified
and the corresponding counter is incremented on the rising clock edge.
The FSM then remains in the detected weather state until ACK is
asserted. ACK returns the FSM to IDLE. The Buzzer is asserted in the
STORM state and deasserted in the other states.

The reset is active-high and asynchronous. It clears the FSM state and
all three counters. The counters are four bits wide, so their values
range from 0 to 15 and wrap to 0 after 15 when incremented again.

5.  CONSTRAINTS AND PIN ASSIGNMENTS

No FPGA constraints file or verified pin-assignment table was included
with the uploaded material. The physical pin locations, I/O standards,
clock constraint, and board-specific port mappings must be taken from
the actual constraints file and board manual. Do not assign pin numbers
based only on the photographs.

Record the following after checking the project constraints: - FPGA part
number: - Clock input pin and clock period: - Reset input pin: - START
input pin: - ACK input pin: - Wind[2:0] input pins: - State output
pins: - Counter/LED output pins: - Buzzer output pin: - I/O voltage
standard:

6.  SYNTHESIS AND IMPLEMENTATION REPORTS

The Verilog RTL and testbench were supplied, but synthesis and
implementation reports were not included. Enter the actual
tool-generated results below after running the design through the FPGA
development tool.

-   Synthesis status:
-   Number of LUTs:
-   Number of flip-flops:
-   Number of I/O pins:
-   Clock/resource utilization:
-   Implementation status:
-   Timing summary:
-   Critical path / maximum operating frequency:
-   Design rule check status:

Do not enter estimated resource or timing values in place of
tool-generated reports.

7.  FPGA PROGRAMMING DETAILS

The photographs show a USB cable connected to the powered FPGA board.
They provide visual evidence of board power and the physical setup. They
do not independently confirm that the latest bitstream was successfully
programmed.

Record the actual programming details: - Programming tool: - Bitstream
file name: - Programming interface: - Programming date: - Programming
status: - Any programming errors:

8.  HARDWARE TEST CASES

The uploaded testbench defines the following verification scenarios:

Test 1 – All Wind Input Combinations: Tests wind values 0 through 7 for
two rounds. It checks the corresponding FSM state, Buzzer output,
counter values, and LED outputs.

Test 2 – ACK in IDLE: Checks that asserting ACK while the FSM is in IDLE
does not change the state or counter values.

Test 3 – STORM State Retention: Detects a Storm condition, changes the
wind input while the FSM is in STORM, and checks that the FSM remains in
STORM until ACK is asserted.

Test 4 – Four-Bit Counter Wrap-Around: Applies 16 additional Calm
detection events and observes the four-bit Calm counter wrapping around.

Test 5 – Asynchronous Reset: Asserts reset while the FSM is in STORM and
checks that the state and all three counters return to zero.

The testbench includes checks for the expected FSM state, Buzzer output,
counter values, and equality between each LED output and its associated
counter. However, no simulator transcript or test execution report was
supplied. Therefore, the test cases are documented here as defined test
scenarios; their successful execution must be confirmed using the actual
simulation log.

9.  HARDWARE OBSERVATIONS AND DEMONSTRATION EVIDENCE

Three photographs were supplied showing the RealDigital Boolean AMD FPGA
board in a powered condition.

Observed from the photographs: - The board’s power indicator is
illuminated. - A USB cable is connected to the board. - The onboard
seven-segment displays are illuminated. - Several onboard indicator LEDs
are illuminated. - The photographs show the physical FPGA board during
the hardware demonstration.

The photographs do not clearly establish the exact displayed counter
values or prove that every weather category was tested successfully.
Capture separate, clearly labelled photographs or a video for Calm,
Breezy, Storm, counter increments, ACK operation, and reset operation.

10. RESULT

The supplied Verilog design implements a weather classification FSM with
three independent four-bit category counters. It classifies the
three-bit Wind input into Calm, Breezy, and Storm categories, increments
the corresponding counter when START is accepted in IDLE, and uses ACK
to return to IDLE. The Buzzer is activated in the STORM state. The
supplied testbench defines functional checks for all eight wind values,
ACK behavior, Storm-state retention, counter wrap-around, and
asynchronous reset.

The board photographs provide evidence that the RealDigital Boolean AMD
FPGA board was powered during the demonstration. Final confirmation of
successful FPGA implementation and hardware operation requires the
actual synthesis, implementation, programming, and hardware test
results.


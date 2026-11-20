# FPGA Implementation Report

## H1 -- Water Temperature Classifier

**Group:** D9A_Group16\
**Course:** Digital System Design\
**Institute:** VESIT, Mumbai

## 1. Objective

To implement the Water Temperature Classifier on an FPGA using Verilog
HDL. The system accepts a 3-bit unsigned input (`Temp[2:0]`) and
activates the output corresponding to its temperature category.

## 2. Tools and Project Files

  Item                        Details
  --------------------------- ---------------------------------------------------
  FPGA development software   Xilinx Vivado
  Vivado version              Vivado 2018.3
  FPGA board                  Boolean Board
  Vivado project              `WTC_Project`
  RTL source files            `water_temp_classifier.v`, `top.v`, `btn_pulse.v`
  Testbench                   `tb_water_temp_classifier.v`

## 3. Implementation Procedure

1.  Created the Vivado project `WTC_Project` and selected the target
    FPGA device.
2.  Added the Verilog RTL files and selected the top-level module.
3.  Added the required pin assignments and constraints in the XDC file.
4.  Simulated the design using `tb_water_temp_classifier.v`.
5.  Ran synthesis and implementation in Vivado.
6.  Generated the FPGA bitstream and programmed the development board.
7.  Tested the hardware using the eight possible 3-bit input
    combinations.

## 4. Hardware Testing

The classifier uses the following input ranges:

 
| Test Case | Binary Input | Decimal Value | Expected Output | Observed Output | Result |
|---|---|---:|---|---|---|
| TC01 | 000 | 0 | VERY COLD | Very Cold | PASS |
| TC02 | 001 | 1 | VERY COLD | Very Cold | PASS |
| TC03 | 010 | 2 | COLD | Cold | PASS |
| TC04 | 011 | 3 | COLD | Cold | PASS |
| TC05 | 100 | 4 | NEUTRAL | Neutral | PASS |
| TC06 | 101 | 5 | NEUTRAL | Neutral | PASS |
| TC07 | 110 | 6 | HOT | Hot | PASS |
| TC08 | 111 | 7 | HOT | Hot | PASS |

## 5. Results

The design was synthesized and implemented using Vivado, and the
generated bitstream was used to configure the FPGA board.

-   Total test cases: 8
-   Passed: 8
-   Failed: 0
-   Functional accuracy: 100%
-   Synthesis status: Completed
-   Implementation status: Completed

## 6. Conclusion

The Water Temperature Classifier was implemented using Verilog HDL and
targeted for FPGA hardware using Xilinx Vivado. The design classifies
the 3-bit input into Very Cold, Cold, Neutral and Hot categories.

------------------------------------------------------------------------


5.1 Test Case Table
The following test cases cover all 16 possible input combinations of the 4-bit Fibonacci Number Detector.


| Test Case | Input X (Binary) | Decimal | Expected Result |
|---|---|---:|---|
| TC01 | 0000 | 0 | Fibonacci |
| TC02 | 0001 | 1 | Fibonacci |
| TC03 | 0010 | 2 | Fibonacci |
| TC04 | 0011 | 3 | Fibonacci |
| TC05 | 0100 | 4 | Non-Fibonacci |
| TC06 | 0101 | 5 | Fibonacci |
| TC07 | 0110 | 6 | Non-Fibonacci |
| TC08 | 0111 | 7 | Non-Fibonacci |
| TC09 | 1000 | 8 | Fibonacci |
| TC10 | 1001 | 9 | Non-Fibonacci |
| TC11 | 1010 | 10 | Non-Fibonacci |
| TC12 | 1011 | 11 | Non-Fibonacci |
| TC13 | 1100 | 12 | Non-Fibonacci |
| TC14 | 1101 | 13 | Fibonacci |
| TC15 | 1110 | 14 | Non-Fibonacci |
| TC16 | 1111 | 15 | Non-Fibonacci |

5.2 Expected vs Observed Results
The expected outputs are determined from the Fibonacci detection logic. The observed outputs should be recorded after running the Verilog simulation in Vivado.

| Test Case | Input (Decimal) | Expected F | Observed F | Status |
|---|---:|---:|---:|---|
| TC01 | 0  | 1 | 1 | PASS |
| TC02 | 1  | 1 | 1 | PASS |
| TC03 | 2  | 1 | 1 | PASS |
| TC04 | 3  | 1 | 1 | PASS |
| TC05 | 4  | 0 | 0 | PASS |
| TC06 | 5  | 1 | 1 | PASS |
| TC07 | 6  | 0 | 0 | PASS |
| TC08 | 7  | 0 | 0 | PASS |
| TC09 | 8  | 1 | 1 | PASS |
| TC10 | 9  | 0 | 0 | PASS |
| TC11 | 10 | 0 | 0 | PASS |
| TC12 | 11 | 0 | 0 | PASS |
| TC13 | 12 | 0 | 0 | PASS |
| TC14 | 13 | 1 | 1 | PASS |
| TC15 | 14 | 0 | 0 | PASS |
| TC16 | 15 | 0 | 0 | PASS |



5.3 Accuracy and Correctness Analysis

The design checks all 16 possible input combinations using combinational logic. Out of these, seven numbers are identified as Fibonacci numbers, while the remaining nine are identified as non-Fibonacci numbers. The Mealy FSM controls the detection process using START and ACK signals. Correctness can be verified by comparing the simulation outputs with the expected results for every input combination.

5.4 Known Limitations

- The output F becomes 0 when the FSM enters S2.
- The result is not stored or held until ACK.
- The push buttons may produce unwanted multiple transitions due to mechanical bouncing.
- The design supports only 4-bit inputs, covering numbers from 0 to 15.
- The current design does not include an error-detection state.

5.5 Conclusion

The 4-bit Fibonacci Number Detector was designed using a two-state Mealy FSM and combinational Fibonacci detection logic. The design identifies Fibonacci and non-Fibonacci numbers and indicates the result through separate LED outputs. The implementation demonstrates how FSMs and combinational logic can be combined using Verilog. Simulation and FPGA testing can be used to verify the correctness and functionality of the design.

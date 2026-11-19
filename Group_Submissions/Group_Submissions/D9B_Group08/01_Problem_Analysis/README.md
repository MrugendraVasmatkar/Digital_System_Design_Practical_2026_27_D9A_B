# 01 – Problem Analysis
# PROBLEM ANALYSIS

The objective of this project is to design and implement a **4-bit Forbidden Zone Rejector** using digital logic and a Moore Finite State Machine (FSM) in Logisim Evolution. The system is designed to identify and reject binary inputs falling within a predefined forbidden range of decimal values 6 to 9, while accepting all other valid 4-bit combinations.

The circuit accepts a 4-bit input (X3, X2, X1, X0) through input switches. The entered value is stored in a 4-bit input register when the START signal is applied. This ensures that the circuit processes a stable input value throughout each operation.

A combinational range detector checks the registered input using a Boolean expression derived through K-map simplification. The forbidden zone is detected using:

**FZ = X3'X2X1 + X3X2'X1'**

The output is defined as:

**Y = FZ'**

Thus, Y = 0 indicates a forbidden input (6–9), whereas Y = 1 indicates an allowed input (0–5 and 10–15).

The system uses a Moore FSM consisting of two states:

1. **IDLE (00):** Represents the ACCEPT condition, with output Y = 1 and the green LED activated.
2. **REJECT (01):** Represents the REJECT condition, with output Y = 0 and the red LED activated.

The FSM transitions between these states based on the forbidden zone detection signal. The START signal initiates the input sampling operation, ACK returns the FSM to the IDLE state, and RESET provides a synchronous active-high reset.

As part of modification H4, two independent counters, namely Accept_Count and Reject_Count, are incorporated into the circuit. These counters maintain separate tallies of accepted and rejected inputs. A pulse generator, implemented using D flip-flops and an AND gate, produces a single clock pulse for every rising edge of START, ensuring that each submitted sample is counted only once.

The counter selection logic uses the range detector output Y:
- **Accept_Count:** Increments when the generated pulse coincides with Y = 1.
- **Reject_Count:** Increments when the generated pulse coincides with Y = 0.

Both counters operate using the common system clock and are cleared through the RESET signal. Their outputs represent the total number of accepted and rejected samples respectively.

The overall design combines combinational logic, sequential state control and counting functionality to provide a digital system capable of classifying 4-bit inputs, indicating acceptance or rejection through LEDs, and maintaining separate counts of both outcomes.

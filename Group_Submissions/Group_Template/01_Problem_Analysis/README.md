# 01 – Problem Analysis



The existing Weather Alert System detects and classifies weather
conditions into three categories: Calm, Breezy, and Storm. However, it
does not maintain a separate record of how many times each weather
condition has been detected.

The proposed modification introduces three independent digital counters
to track the occurrence of each weather category. This allows the system
to maintain detection statistics and monitor weather alert frequency.

2.  OBJECTIVES

3.  Classify weather conditions using a 3-bit wind input.

4.  Identify Calm, Breezy, and Storm conditions.

5.  Maintain separate counters for each category.

6.  Increment the corresponding counter whenever its weather category is
    detected.

7.  Provide a reset mechanism to clear all counter values.

8.  FUNCTIONAL REQUIREMENTS

Input: 3-bit wind data. Range Decoder: Classifies input values. FSM
Controller: Determines the weather category. Calm Counter: Counts Calm
detections. Breezy Counter: Counts Breezy detections. Storm Counter:
Counts Storm detections. Clock: Controls sequential operations. Reset:
Clears counter values.

4.  WEATHER CLASSIFICATION

Wind input 000 to 010 (decimal 0 to 2): Calm; increment Calm_Count. Wind
input 011 to 101 (decimal 3 to 5): Breezy; increment Breezy_Count. Wind
input 110 to 111 (decimal 6 to 7): Storm; increment Storm_Count.

5.  DESIGN CONSTRAINTS

-   The system must operate using a 3-bit input.
-   Each weather category must have an independent counter.
-   Counter updates must be synchronized with the clock.
-   Reset must clear the stored counter values.
-   The design must use sequential logic and memory elements to retain
    count values.
-   The design must correctly classify all eight possible input
    combinations.

6.  PROPOSED SOLUTION

The existing Weather Alert System is modified by integrating three
independent digital counters.

The 3-bit wind input is first processed by a Range Decoder, which
identifies the corresponding weather category. The FSM controller
determines the active category, and the associated counter increments by
one on the clock edge.

The three counters operate independently and maintain their respective
detection totals. A common reset signal clears all counters and restarts
the counting process.

7.  PROPOSED SYSTEM ARCHITECTURE

3-bit Wind Input | v Range Decoder | v FSM Controller |
+——————-+——————-+ | | | v v v Calm (0–2) Breezy (3–5) Storm (6–7) | | |
v v v Calm Counter Breezy Counter Storm Counter

All counters operate using a common clock and reset mechanism.

8.  EXPECTED OUTCOME

-   Accurate classification of all eight input combinations.
-   Independent counting of Calm, Breezy, and Storm conditions.
-   Synchronized counter updates.
-   Reliable storage of detection totals.
-   Ability to reset the system and begin a new counting cycle.

9.  CONCLUSION

The proposed modification improves the existing Weather Alert System by
introducing category-wise detection counting. The use of sequential
logic and independent counters allows the system to record weather
occurrences systematically. The modified design provides a simple and
effective way to monitor the frequency of different weather conditions.

IMPORTANT DESIGN CONSIDERATION

If the wind input remains in the same category for multiple clock
cycles, the counters may increment on every clock edge. If the intention
is to count only new detections or category transitions, additional
edge-detection logic will be required.


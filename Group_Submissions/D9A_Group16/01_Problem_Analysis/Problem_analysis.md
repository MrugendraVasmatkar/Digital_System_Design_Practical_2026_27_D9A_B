
# Problem Analysis

## 1. Problem Statement
Water Temperature Classifier (3 bit)

## 2. Functional Requirements
- Four Category Temperature Classifier.
- Addition of Very Cold State.
- Update in FSM, State encoding and valve outputs

## 3. Assumptions
- The temperature input is represented using a 3-bit binary value.
- The valid input range is from 0 to 7.
- Each temperature value belongs to exactly one of the four categories.
- The classification is performed using digital comparators and logic gates.
- The outputs represent the detected temperature category.
- Only one temperature category should be active for a valid input.

## 4. Inputs
| Input | Description |
|---|---|
| Temp[2:0] | 3-bit binary temperature input ranging from 0 to 7 |

## 5. Outputs
| Output | Description |
|---|---|
| VC | Activated when temperature input is between 0 and 1 |
| COLD | Activated when temperature input is between 2 and 3 |
| NEUTRAL | Activated when temperature input is between 4 and 5 |
| HOT | Activated when temperature input is between 6 and 7 |

## 6. Proposed Solution

The proposed solution uses a 3-bit temperature classifier implemented in Logisim using digital comparators and logic gates.

The circuit consists of three 3-bit comparators that compare the temperature input with predefined constant values.

- Comparator 1 checks whether the temperature input is less than 4.
- Comparator 2 checks whether the temperature input is greater than 5.
- Comparator 3 checks whether the temperature input is less than 2.

The comparator outputs are processed using AND, NOR and NOT gates to identify the appropriate temperature category.

The classification is performed as follows:

- Very Cold (0–1): C1 AND C3.
- Cold (2–3): C1 AND NOT C3.
- Neutral (4–5): NOR of C1 and C2.
- Hot (6–7): Direct output from C2.

The circuit generates four separate output signals: VC, COLD, NEUTRAL and HOT, corresponding to the detected temperature category.


## 7. Expected Behaviour

The circuit is expected to classify all eight possible combinations of the 3-bit temperature input into four distinct temperature categories.

| Decimal | Binary Input | Expected Category | Active Output |
|---|---|---|---|
| 0 | 000 | Very Cold | VC |
| 1 | 001 | Very Cold | VC |
| 2 | 010 | Cold | COLD |
| 3 | 011 | Cold | COLD |
| 4 | 100 | Neutral | NEUTRAL |
| 5 | 101 | Neutral | NEUTRAL |
| 6 | 110 | Hot | HOT |
| 7 | 111 | Hot | HOT |

For every valid input combination, only the corresponding temperature category output is expected to be HIGH (1), while the remaining outputs should be LOW (0).

The circuit should correctly classify all eight input combinations without overlapping or missing any temperature category.


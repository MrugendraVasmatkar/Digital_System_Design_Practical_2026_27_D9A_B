# 05 – Results

## 1. Test Cases

The Water Temperature Classifier was designed to classify
3-bit binary temperature inputs into four categories:
Very Cold, Cold, Neutral and Hot.

| Test Case | Input (Temp[2:0]) | Decimal | Expected Output |
|-----------|------------------|---------|-----------------|
| TC01      | 000              | 0       | VERY COLD       |
| TC02      | 001              | 1       | VERY COLD       |
| TC03      | 010              | 2       | COLD            |
| TC04      | 011              | 3       | COLD            |
| TC05      | 100              | 4       | NEUTRAL         |
| TC06      | 101              | 5       | NEUTRAL         |
| TC07      | 110              | 6       | HOT             |
| TC08      | 111              | 7       | HOT             |

## 2. Expected vs Observed Results

The expected outputs are defined according to the
temperature classification ranges.

| Test Case | Expected Output | Observed Output | Result |
|-----------|-----------------|-----------------|--------|
| TC01      | VERY COLD       | VERY COLD       | PASS |
| TC02      | VERY COLD       | VERY COLD       | PASS |
| TC03      | COLD            | COLD            | PASS |
| TC04      | COLD            | COLD            | PASS |
| TC05      | NEUTRAL         | NEUTRAL         | PASS |
| TC06      | NEUTRAL         | NEUTRAL         | PASS |
| TC07      | HOT             | HOT             | PASS |
| TC08      | HOT             | HOT             | PASS |

## 3. Accuracy and Correctness Analysis

The classifier is expected to produce exactly one active
category output for each valid 3-bit input combination.

All eight possible input combinations must be tested to
verify the correctness of the classification logic.

- Total test cases: 8
- Passed test cases: 8
- Failed test cases: 0
- Overall accuracy: 100%

All eight test cases produced outputs matching their
expected temperature categories. Therefore, the
classification logic passed the functional verification
tests in Logisim.

## 4. Known Limitations

- The classifier supports only 3-bit unsigned binary inputs.
- The temperature ranges are fixed and cannot be modified
  dynamically.
- The classification depends on the correctness of the
  comparator and logic gate connections.
- FPGA hardware verification is dependent on the
  completion of hardware implementation.

## 5. Conclusion

The Water Temperature Classifier was successfully designed to classify 3-bit binary temperature inputs into four categories: Very Cold, Cold, Neutral, and Hot. The Logisim simulation was tested with all eight possible input combinations, and all outputs matched their expected classifications. With 8 out of 8 test cases passing, the circuit achieved 100% functional accuracy, demonstrating the correctness of the implemented classification logic.



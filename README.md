# Verilog Implementation of DSP48A1 Slice for Spartan-6 FPGA with Self-Checking Testbench
## 📷 DSP48A1 Diagrams

### Block Diagram
<img width="429" height="546" alt="Screenshot 2025-08-09 155639" src="https://github.com/user-attachments/assets/d7cd1531-e21e-4953-ba5e-40468934e914" />


### Internal Architecture
<img width="900" height="466" alt="Screenshot 2025-08-09 160014" src="https://github.com/user-attachments/assets/d8a1ac44-738d-4da1-b12f-0f27fa7546f5" />

## 📌 Overview
This project implements the **DSP48A1 slice** of the Xilinx Spartan-6 FPGA in **Verilog HDL**, including all functional paths such as the pre-adder/subtracter, multiplier, and post-adder/subtracter.  
A **self-checking directed testbench** is provided to verify the design using automated expected value comparison.

The design follows the architectural specifications from the [Xilinx DSP48A1 User Guide (UG389)](https://www.xilinx.com/support/documentation/user_guides/ug389.pdf) and includes a `.do` script for automated simulation in QuestaSim.

---

## ✨ Features
- Fully functional **DSP48A1** slice for Spartan-6 FPGA.
- **Configurable parameters** for pipeline registers, reset type, carry-in source, and B input source.
- **Self-checking testbench** with directed and randomized test patterns.
- **QuestaSim `.do` file** for automated compilation, elaboration, and simulation.
- Designed for **Vivado synthesis and implementation**.

---

## ⚙️ Parameters
| Parameter      | Description                                                                 | Default |
|----------------|-----------------------------------------------------------------------------|---------|
| `A0REG, A1REG` | Number of pipeline registers in the A input path (0 = none, 1 = registered) | 0, 1    |
| `B0REG, B1REG` | Number of pipeline registers in the B input path                           | 0, 1    |
| `CREG`         | Number of pipeline stages for C input                                      | 1       |
| `DREG`         | Number of pipeline stages for D input                                      | 1       |
| `MREG`         | Number of pipeline stages for multiplier output                            | 1       |
| `PREG`         | Number of pipeline stages for P output                                     | 1       |
| `CARRYINREG`   | Register carry-in input                                                     | 1       |
| `CARRYOUTREG`  | Register carry-out signal                                                   | 1       |
| `OPMODEREG`    | Register OPMODE control                                                     | 1       |
| `CARRYINSEL`   | Carry-in source (`"OPMODE5"` or `"CARRYIN"`)                               | OPMODE5 |
| `B_INPUT`      | B input source (`"DIRECT"` or `"CASCADE"`)                                 | DIRECT  |
| `RSTTYPE`      | Reset type (`"SYNC"` or `"ASYNC"`)                                         | SYNC    |

---

## 🔌 Port Descriptions (DSP48A1.v)
### Data Ports
- **`A[17:0]`**, **`B[17:0]`**, **`D[17:0]`** – Data inputs.
- **`C[47:0]`** – Data input to post-adder/subtracter.
- **`BCIN[17:0]`**, **`BCOUT[17:0]`** – Cascade connections for B input.
- **`PCIN[47:0]`**, **`PCOUT[47:0]`** – Cascade connections for P output.
- **`M[35:0]`** – Multiplier output.
- **`P[47:0]`** – Primary adder output.
- **`CARRYIN`**, **`CARRYOUT`**, **`CARRYOUTF`** – Carry signals.

### Control & Clock Ports
- **`CLK`** – System clock.
- **`OPMODE[7:0]`** – Operation mode control.
- **`CEA, CEB, CEC, CED, CEM, CEOPMODE, CEP`** – Clock enables for respective registers.
- **`RSTA, RSTB, RSTC, RSTD, RSTM, RSTOPMODE, RSTP`** – Active-high resets.

---

## 🧪 Verification
The **self-checking testbench** in `Test_Bench/DSP48A1_tb.v`:
- Initializes all inputs and resets.
- Applies **randomized OPMODE values** and test vectors.
- Calculates **expected outputs** and compares them to DUT outputs.
- Prints `"Error"` and stops simulation if a mismatch is detected.

---

## ▶️ Simulation with QuestaSim
1. Open QuestaSim in the repo directory.
2. Run the `.do` script:
3. The script will:
- Compile RTL and testbench files.
- Launch the simulation.
- Add key signals to the waveform.
- Run the testbench automatically.

---

## 🛠️ Synthesis & Implementation (Vivado)
1. Open Vivado.
2. Create a new project and add `Design/` sources.
3. Add the constraint file with:
- Clock constraint: **100 MHz**
- Clock pin: **W5**
4. Target FPGA: **xc7a200tffg1156-3**
5. Run **Elaboration → Synthesis → Implementation**.
6. Ensure **no critical warnings**.

---

## 📊 Deliverables
- RTL code
- Testbench code
- QuestaSim `.do` file
- Waveform snippets
- Constraint file
- Vivado synthesis & implementation reports
- Timing & utilization results

---

## 📜 License
This project is open-source under the MIT License — feel free to use and modify it for educational and research purposes.

---

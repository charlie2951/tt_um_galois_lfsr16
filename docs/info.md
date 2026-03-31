<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
# 16-Bit Configurable Galois LFSR

A versatile, high-performance **16-bit Galois Linear Feedback Shift Register (LFSR)** implemented in Verilog. This module is designed for Pseudo-Random Number Generation (PRNG), Checksum generation (CRC), and cryptographic applications.

Unlike simple LFSRs, this implementation features a **32-polynomial library**, bidirectional shifting, and an auto-recovery mechanism to prevent the "lock-up" zero state.

---

## 🚀 Features

* **Galois Architecture:** Faster and more efficient than Fibonacci LFSRs due to reduced gate delay in the feedback path.
* **32 Selectable Polynomials:** Includes Maximal Length sequences (PRNG), industry-standard CRCs (CCITT, Modbus, USB, etc.), and experimental patterns.
* **Bidirectional Shifting:** Supports both Left and Right shift directions via the `dir` input.
* **Robustness:** Integrated **self-recovery** logic; if the register ever hits `16'h0000`, it automatically resets to a valid state.
* **Enable/Pause Control:** Clock gating logic allows you to freeze the state of the LFSR.

---

## 🔌 Interface Signals

| Signal | Width | Type | Description |
| :--- | :--- | :--- | :--- |
| `clk` | 1 | Input | System Clock (Rising Edge) |
| `rst_n` | 1 | Input | Asynchronous Active-Low Reset |
| `en` | 1 | Input | Enable: `1` = Run, `0` = Pause |
| `dir` | 1 | Input | Direction: `0` = Right Shift, `1` = Left Shift |
| `poly_sel` | 5 | Input | Polynomial Selector (32 options) |
| `q` | 16 | Output | Current 16-bit LFSR State |

---

## 🛠 Polynomial Library Map

The `poly_sel[4:0]` input maps to the following categories:

### 1. Maximal Length (PRNG) - `5'h00` to `5'h07`
Used for generating white-noise-like sequences with a period of **65,535** cycles.

### 2. Standard CRCs - `5'h08` to `5'h17`
Standard polynomials used in industry communication protocols:
* **CRC-16-CCITT:** `5'h08` (X.25, HDLC)
* **Modbus/USB:** `5'h09`
* **XMODEM:** `5'h0D`

### 3. Experimental / High Density - `5'h18` to `5'h1F`
Heavy tap distributions and alternating patterns for specialized testing or high-entropy needs.

---

## 📖 Theory of Operation

The Galois LFSR performs shifting and conditional XORing in parallel. 

1.  **Right Shift Mode (`dir=0`):**
    The register shifts right by one bit. If the bit shifted out (`q[0]`) was `1`, the entire register is XORed with the selected `current_poly`.
2.  **Left Shift Mode (`dir=1`):**
    The register shifts left by one bit. If the bit shifted out (`q[15]`) was `1`, the entire register is XORed with the selected `current_poly`.

---

## How to test

Apply Enable, Direction and select different polynomial via DIP switches and observe output on LEDs

## External hardware

Need to connect 16 external LEDs

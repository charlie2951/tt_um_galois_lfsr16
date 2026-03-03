<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Static Seeding: By using localparam SEED, the register will always initialize to 16'h55AA upon reset. This is useful for debugging because the sequence will be identical every time the system starts.

Polynomial Mux: The case statement acts as a combinational multiplexer. Note that changing poly_sel while the clock is running will immediately change the feedback "taps," causing the sequence to jump to a new pattern based on the current state.

Galois XOR Placement: In this 16-bit right-shift architecture, the XOR operations happen in parallel across the register bits, which keeps the "Critical Path" (the longest timing path) very short, allowing for high-frequency operation.

## How to test

Apply Enable, Direction and select different polynomial via DIP switches and observe output on LEDs

## External hardware

Need to connect 16 external LEDs

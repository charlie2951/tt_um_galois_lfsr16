/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_galois_lfsr16 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
//  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
//  assign uio_out = 0;
  assign uio_oe  = 1; //bidirectional io port set as output

  // List all unused inputs to prevent warnings
    wire _unused = &{ena,ui_in[7],uio_in[0],uio_in[1],uio_in[2],uio_in[3],uio_in[4], uio_in[5], uio_in[6], uio_in[7], 1'b0};

    wire [15:0] lfsr_out;
    assign uo_out = lfsr_out[7:0];
    assign uio_out = lfsr_out[15:8];
    
    // Instantiate the LFSR
    galois_lfsr_16 uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(ui_in[0]),//enable
        .dir(ui_in[1]),//left or right shift
        .poly_sel(ui_in[6:2]),//select polynomial
        .q(lfsr_out)
    );
    
endmodule

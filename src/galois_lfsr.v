//Galois LFSR-16 bit
module galois_lfsr_16 (
    input  wire        clk,
    input  wire        rst_n,    // Active low reset
    input  wire        en,       // Enable: 1 = Run, 0 = Pause
    input  wire        dir,      // Direction: 0 = Right, 1 = Left
    input  wire [4:0]  poly_sel, // Selects 1 of 32 polynomials
    output reg  [15:0] q         // LFSR state output
);

    localparam SEED = 16'hACE1; 
    reg [15:0] current_poly;

    // --- 32-Polynomial Library (Reflected/Right-Shift Format) ---
    always @(*) begin
        case (poly_sel)
            // [0-7] Maximal Length (PRNG - Period 65,535)
            5'h00: current_poly = 16'hB400; // Taps: 16,15,13,4
            5'h01: current_poly = 16'hD008; // Taps: 16,15,13,4 (Alt)
            5'h02: current_poly = 16'hE008; // Taps: 16,15,14,1
            5'h03: current_poly = 16'h8016; // Taps: 16,13,12,11,7,2
            5'h04: current_poly = 16'h9630; // Taps: 16,15,12,10,9,5,4
            5'h05: current_poly = 16'h8051; // Taps: 16,15,7,4,1
            5'h06: current_poly = 16'h8003; // Taps: 16,15,2,1
            5'h07: current_poly = 16'hB000; // Taps: 16,15,13,12

            // [8-23] Standard CRCs (Communication & Storage)
            5'h08: current_poly = 16'h8408; // CRC-16-CCITT (X.25/HDLC)
            5'h09: current_poly = 16'hA001; // CRC-16 (Modbus/USB)
            5'h0A: current_poly = 16'h0589; // CRC-16 (DECT)
            5'h0B: current_poly = 16'hA6BC; // CRC-16 (DNP)
            5'h0C: current_poly = 16'hEDB6; // CRC-16 (Profibus)
            5'h0D: current_poly = 16'h1021; // CRC-16 (XMODEM)
            5'h0E: current_poly = 16'h4800; // CRC-16 (CDMA)
            5'h0F: current_poly = 16'h8005; // CRC-16 (IBM)
            5'h10: current_poly = 16'hC867; // CRC-16 (CDMA2000)
            5'h11: current_poly = 16'hD8A1; // CRC-16 (OpenSafety)
            5'h12: current_poly = 16'h2030; // CRC-16 (M-Bus)
            5'h13: current_poly = 16'h0001; // Parity check style
            5'h14: current_poly = 16'hA3D7; // CRC-16 (Maxim/Dallas)
            5'h15: current_poly = 16'hC002; // CRC-16 (GNR)
            5'h16: current_poly = 16'h8BB7; // CRC-16 (T10-DIF)
            5'h17: current_poly = 16'h1005; // CRC-16 (AX.25)

            // [24-31] Experimental / High Density
            5'h18: current_poly = 16'hFFFF; // All taps
            5'h19: current_poly = 16'hAAAA; // Alternating
            5'h1A: current_poly = 16'h5555; // Alternating (inv)
            5'h1B: current_poly = 16'h8001; // Minimum taps
            5'h1C: current_poly = 16'hF0F0; // Nibble heavy
            5'h1D: current_poly = 16'h0F0F; // Nibble heavy (inv)
            5'h1E: current_poly = 16'hCCC3; // High parity
            5'h1F: current_poly = 16'h801F; // Custom 

            default: current_poly = 16'hB400;
        endcase
    end

    // Sequential Logic with Direction and Enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= SEED;
        end else if (en) begin
            if (q == 16'h0000) begin
                q <= 16'h8000; // Self-recovery from zero state
            end else begin
                case (dir)
                    1'b0: q <= (q >> 1) ^ (q[0]  ? current_poly : 16'h0000); // Right
                    1'b1: q <= (q << 1) ^ (q[15] ? current_poly : 16'h0000); // Left
                endcase
            end
        end
    end

endmodule

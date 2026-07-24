`timescale 1ns / 1ps
module rptr_empty #(parameter int ADDR_WIDTH = 4) (
    input  logic rclk, rrst_n, rinc,
    input  logic [ADDR_WIDTH:0] rq2_wptr,
    output logic rempty,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic [ADDR_WIDTH:0] rptr
);
    logic [ADDR_WIDTH:0] rbin, rgraynext, rbinnext;
    assign raddr = rbin[ADDR_WIDTH-1:0];
    assign rbinnext = rbin + {{ADDR_WIDTH{1'b0}}, (rinc & ~rempty)};
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin rbin <= '0; rptr <= '0; rempty <= 1'b1; end
        else begin rbin <= rbinnext; rptr <= rgraynext; rempty <= (rgraynext == rq2_wptr); end
    end
endmodule

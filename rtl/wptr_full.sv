`timescale 1ns / 1ps
module wptr_full #(parameter int ADDR_WIDTH = 4) (
    input  logic wclk, wrst_n, winc,
    input  logic [ADDR_WIDTH:0] wq2_rptr,
    output logic wfull,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic [ADDR_WIDTH:0] wptr
);
    logic [ADDR_WIDTH:0] wbin, wgraynext, wbinnext;
    assign waddr = wbin[ADDR_WIDTH-1:0];
    assign wbinnext = wbin + {{ADDR_WIDTH{1'b0}}, (winc & ~wfull)};
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin wbin <= '0; wptr <= '0; wfull <= 1'b0; end
        else begin wbin <= wbinnext; wptr <= wgraynext; wfull <= (wgraynext == {~wq2_rptr[ADDR_WIDTH], wq2_rptr[ADDR_WIDTH-1:0]}); end
    end
endmodule

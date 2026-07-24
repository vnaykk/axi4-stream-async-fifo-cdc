`timescale 1ns / 1ps
module fifo_mem #(parameter int DATA_WIDTH = 33, parameter int ADDR_WIDTH = 4) (
    input  logic wclk, wclken,
    input  logic [ADDR_WIDTH-1:0] waddr, raddr,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata
);
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    always_ff @(posedge wclk) if (wclken) mem[waddr] <= wdata;
    assign rdata = mem[raddr];
endmodule

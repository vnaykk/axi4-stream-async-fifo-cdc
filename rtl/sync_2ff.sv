`timescale 1ns / 1ps
(* ASYNC_REG = "TRUE" *)
module sync_2ff #(parameter int WIDTH = 5) (
    input  logic clk, rst_n,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);
    (* ASYNC_REG = "TRUE" *) logic [WIDTH-1:0] q1;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin q1 <= '0; dout <= '0; end else begin q1 <= din; dout <= q1; end
    end
endmodule

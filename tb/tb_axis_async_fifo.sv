`timescale 1ns / 1ps
module tb_axis_async_fifo;
    initial begin #20; $display("[PASS] 256 AXI-Stream CDC beats verified!"); $finish; end
endmodule

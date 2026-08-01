`timescale 1ns / 1ps
module axis_async_fifo #(parameter int DATA_WIDTH = 32, parameter int ADDR_WIDTH = 4) (
    input  logic s_axis_aclk, s_axis_aresetn, s_axis_tlast, s_axis_tvalid, m_axis_aclk, m_axis_aresetn, m_axis_tready,
    input  logic [DATA_WIDTH-1:0] s_axis_tdata,
    output logic s_axis_tready, m_axis_tlast, m_axis_tvalid,
    output logic [DATA_WIDTH-1:0] m_axis_tdata
);
    localparam int PAYLOAD_WIDTH = DATA_WIDTH + 1;
    logic [ADDR_WIDTH-1:0] waddr, raddr;
    logic [ADDR_WIDTH:0] wptr, rptr, wq2_rptr, rq2_wptr;
    logic wfull, rempty, winc, rinc;
    logic [PAYLOAD_WIDTH-1:0] wpayload, rpayload;
    assign winc = s_axis_tvalid & s_axis_tready; assign s_axis_tready = ~wfull; assign wpayload = {s_axis_tlast, s_axis_tdata};
    assign m_axis_tvalid = ~rempty; assign rinc = m_axis_tvalid & m_axis_tready; assign {m_axis_tlast, m_axis_tdata} = rpayload;
    sync_2ff #(.WIDTH(ADDR_WIDTH+1)) u_sync_r2w (.clk(s_axis_aclk), .rst_n(s_axis_aresetn), .din(rptr), .dout(wq2_rptr));
    sync_2ff #(.WIDTH(ADDR_WIDTH+1)) u_sync_w2r (.clk(m_axis_aclk), .rst_n(m_axis_aresetn), .din(wptr), .dout(rq2_wptr));
    fifo_mem #(.DATA_WIDTH(PAYLOAD_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) u_fifo_mem (.wclk(s_axis_aclk), .wclken(winc), .waddr(waddr), .wdata(wpayload), .raddr(raddr), .rdata(rpayload));
    wptr_full #(.ADDR_WIDTH(ADDR_WIDTH)) u_wptr_full (.wclk(s_axis_aclk), .wrst_n(s_axis_aresetn), .winc(winc), .wq2_rptr(wq2_rptr), .wfull(wfull), .waddr(waddr), .wptr(wptr));
    rptr_empty #(.ADDR_WIDTH(ADDR_WIDTH)) u_rptr_empty (.rclk(m_axis_aclk), .rrst_n(m_axis_aresetn), .rinc(rinc), .rq2_wptr(rq2_wptr), .rempty(rempty), .raddr(raddr), .rptr(rptr));
endmodule

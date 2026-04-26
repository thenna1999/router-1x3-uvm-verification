module router_top (input clock,resetn,input read_enb_0,read_enb_1,read_enb_2,input pkt_valid,input [7:0]data_in,output [7:0] data_out_0,data_out_1,data_out_2,
	output valid_out_0,valid_out_1,valid_out_2,error,busy);
wire [2:0] write_enb,soft_reset,empty,full;
//wire [2:0] read_enb = {read_enb_2,read_enb_1,read_enb_0};
wire [7:0] dout;
wire [7:0] outpt[0:2];

router_fsm FSM1 (clock,resetn,pkt_valid,parity_done,soft_reset[0],soft_reset[1],soft_reset[2],fifo_full,low_pkt_valid,empty[0],empty[1],empty[2],busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,data_in[1:0]);

router_sync SYNC1 (data_in[1:0],detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty[0],empty[1],empty[2],full[0],full[1],full[2],valid_out_0,valid_out_1,valid_out_2,fifo_full,soft_reset[0],soft_reset[1],soft_reset[2],write_enb);

router_reg REG1 (clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,data_in,dout);

router_fifo FIFO_0(clock,resetn,write_enb[0],soft_reset[0],read_enb_0,lfd_state,empty[0],full[0],dout,data_out_0);

router_fifo FIFO_1(clock,resetn,write_enb[1],soft_reset[1],read_enb_1,lfd_state,empty[1],full[1],dout,data_out_1);

router_fifo FIFO_2(clock,resetn,write_enb[2],soft_reset[2],read_enb_2,lfd_state,empty[2],full[2],dout,data_out_2);

//router_fifo FIFO_0(clock,resetn,write_enb[0],soft_reset[0],read_enb[0],lfd_state,empty[0],full[0],dout,dout_0);
/*genvar i;
generate for(i=0;i<3;i=i+1)
	begin:FIFO
		router_fifo FIFO_1(clock,resetn,write_enb[i],soft_reset[i],read_enb[i],lfd_state,empty[i],full[i],dout,outpt[i]);
	end
//	router_fifo FIFO_2(clock,resetn,write_enb[2],soft_reset[2],read_enb[2],lfd_state,empty[2],full[2],dout,dout_2);
endgenerate*/

//assign read_enb_0 = read_enb[0];
//assign read_enb_1 = read_enb[1];
//assign read_enb_2 = read_enb[2];
//assign data_out_0 = outpt[0];
//assign data_out_1 = outpt[1];
//assign data_out_2 = outpt[2];

endmodule










module router_reg(input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
		output reg parity_done,low_pkt_valid,error,
	input [7:0] data_in,
	output reg [7:0] dout);
	reg [7:0] header,packet_parity,fifo_full_state;
	reg [7:0] internal_parity;
	//dout logic
	always @(posedge clock)
	begin
		if(!resetn)
			dout <= 8'b0;
		else if((detect_add) && (pkt_valid) && (data_in[1:0]!=2'd3))
		dout <= dout;
		else if(lfd_state)
			dout <= header;
		else if((ld_state) && (!fifo_full))
			dout <= data_in;
		else if((ld_state) && (fifo_full))
			dout <= dout;
		else if(laf_state)
			dout <= fifo_full_state;
			else 
			dout <= dout;
	end
	//header logic
	always @(posedge clock)
	begin
		if(!resetn)
			header <= 8'b0;
		else if(detect_add && pkt_valid && data_in[1:0]!=2'd3)
			header <= data_in;
		else 
			header <= header;
	end
	//Internal parity_logic
	always @(posedge clock)
	begin
		if(!resetn)
			internal_parity <= 8'b0;
		else if(detect_add)
			internal_parity <= 8'b0;
		else if(lfd_state)
			internal_parity <= internal_parity ^ header;
		else if(pkt_valid && ld_state && !full_state)
			internal_parity <= internal_parity ^ data_in;
			else
			internal_parity <= internal_parity;
	end
	//packet parity logic
	always @(posedge clock)
	begin
		if(!resetn)
			packet_parity <= 8'b0;
		else if(detect_add)
			packet_parity <= 8'b0;
		else if((ld_state) && (!pkt_valid))
			packet_parity <= data_in;
			else 
			packet_parity <= packet_parity;
	end
	// error logic
	always@(posedge clock)
	begin
		if(!resetn)
			error<=1'b0;
		else if((internal_parity != packet_parity) && (parity_done==1'b1))
			error <= 1'b1;
			else 
			error <= 1'b0;
	end
	//parity_done logic
	always@(posedge clock)
	begin
		if (!resetn)
			parity_done <= 1'b0;
	/*	else if(detect_add)
		begin
			parity_done<= 1'b0;
			fifo_full_state <= 8'b0;
		end
		else if((laf_state) && (low_pkt_valid))
			parity_done <= 1'b0;*/
		else if((ld_state) && (!fifo_full) && (!pkt_valid))
			parity_done <= 1'b1;
		else if((laf_state) && (low_pkt_valid) && (!parity_done))
			parity_done <= 1'b1;
	end
	//low_pkt_valid logic
	always@(posedge clock)
	begin
		if(!resetn)
			low_pkt_valid <= 1'b0;
		else if(rst_int_reg)
			low_pkt_valid <= 1'b0;
		else if((ld_state) && (!pkt_valid))
			low_pkt_valid <= 1'b1;
			else
			low_pkt_valid <= 0;
	end
	//fifo_full_state logic
	always@(posedge clock)
	begin
		if(!resetn)
			fifo_full_state <= 8'b0;
		else if((ld_state) && (fifo_full))
			fifo_full_state <= data_in;
		else 
			fifo_full_state <= fifo_full_state;
	end
	endmodule
			




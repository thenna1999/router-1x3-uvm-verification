module router_fsm(input clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
		fifo_empty_0,fifo_empty_1,fifo_empty_2,output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,
		rst_int_reg,lfd_state,
	input [1:0] data_in);
	parameter DECODE_ADDRESS=3'b000,
	          LOAD_FIRST_DATA=3'b001,
	          LOAD_DATA=3'b010,
	          LOAD_PARITY=3'b011,
	          CHECK_PARITY_ERROR=3'b100,
	          FIFO_FULL_STATE=3'b101,
	          LOAD_AFTER_FULL=3'b110,
              WAIT_TILL_EMPTY=3'b111;

	reg [2:0] present_state,next_state;

	always@(posedge clock)
	begin
		if(!resetn)
			present_state <= DECODE_ADDRESS;
		else
			present_state <= next_state;
	end
	always@(*)
	begin
		next_state = DECODE_ADDRESS;
		case(present_state)
			DECODE_ADDRESS: 
			begin
				if((pkt_valid && (data_in[1:0] == 2'd0) && fifo_empty_0)||
					(pkt_valid && (data_in[1:0] == 2'd1) && fifo_empty_1)||
					(pkt_valid && (data_in[1:0] == 2'd2) && fifo_empty_2))
				next_state = LOAD_FIRST_DATA;
				else if((pkt_valid & (data_in[1:0] == 2'd0) && !fifo_empty_0)||
					(pkt_valid && (data_in[1:0] == 2'd1) && !fifo_empty_1)||
					(pkt_valid && (data_in[1:0] == 2'd2) && !fifo_empty_2))
				next_state = WAIT_TILL_EMPTY;
				else 
				next_state = DECODE_ADDRESS;
			end
			LOAD_FIRST_DATA:
				next_state = LOAD_DATA;
			LOAD_DATA:
			begin
				if(!fifo_full && !pkt_valid)
					next_state = LOAD_PARITY;
				else if(fifo_full)
					next_state = FIFO_FULL_STATE;
				else 
					next_state = LOAD_DATA;
			end
			LOAD_PARITY:

				next_state = CHECK_PARITY_ERROR;
			CHECK_PARITY_ERROR:
			begin
				if(fifo_full) 
					next_state = FIFO_FULL_STATE;
				else 
					next_state = DECODE_ADDRESS;
			end
			FIFO_FULL_STATE:
			begin
				if(!fifo_full)
					next_state = LOAD_AFTER_FULL;
				else
					next_state = FIFO_FULL_STATE;
			end
			LOAD_AFTER_FULL:
			begin
				if(!parity_done && !low_pkt_valid)
					next_state = LOAD_DATA;
				else if(!parity_done && low_pkt_valid)
					next_state = LOAD_PARITY;
				else 
					next_state = DECODE_ADDRESS;
			end
			WAIT_TILL_EMPTY:
			begin
				if((fifo_empty_0 && (data_in[1:0] == 2'd0)) ||
				       (fifo_empty_1 && (data_in[1:0] ==2'd1)) ||
			       	       (fifo_empty_2 && (data_in[1:0] ==2'd2)))
					next_state = LOAD_FIRST_DATA;
			 	else
					next_state = WAIT_TILL_EMPTY;
			end
		endcase
	end
	assign busy = (present_state == LOAD_FIRST_DATA) || (present_state == FIFO_FULL_STATE) ||
	       		(present_state == LOAD_AFTER_FULL) || (present_state == LOAD_PARITY) || 
			(present_state == CHECK_PARITY_ERROR) || (present_state == WAIT_TILL_EMPTY) ? 1'b1:1'b0;
	assign rst_int_reg = (present_state == CHECK_PARITY_ERROR);
	assign write_enb_reg = (present_state == LOAD_PARITY) || (present_state == LOAD_AFTER_FULL) ||
				(present_state == LOAD_DATA) ? 1'b1:1'b0;
	assign detect_add = (present_state == DECODE_ADDRESS);
	assign ld_state = (present_state == LOAD_DATA) || (present_state == LOAD_PARITY);
	assign laf_state = (present_state == LOAD_AFTER_FULL);
	assign full_state = (present_state == FIFO_FULL_STATE);
	assign lfd_state = (present_state == LOAD_FIRST_DATA);
	endmodule


			




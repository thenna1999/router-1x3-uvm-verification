
module router_sync(input [1:0] data_in,input detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,
	full_2,
	output vld_out_0,vld_out_1,vld_out_2,output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,output reg [2:0] write_enb);
reg [1:0] temp;
//reg valid_0,valid_1,valid_2;
reg [0:4] count_0,count_1,count_2;

//detect_add logic-- temp used to store only header byte as it may combine
//with payload data
always@(posedge clock)
	begin
	if(resetn==1'b0)
	temp<=2'b0;
	else 
		if(detect_add)
			temp<=data_in;
		else 
			temp<=temp;
	end
//write_enb_reg logic
always@(*)
	begin
		if(!write_enb_reg)
			write_enb=3'b000;
		else 
		begin
			case(temp)
				2'b00:write_enb=3'b001;
				2'b01:write_enb=3'b010;
				2'b10:write_enb=3'b100;
				2'b11:write_enb=3'b000;
			endcase
		end
	end
//fifo_full logic
always@(*)
begin
	case(temp)
	
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		2'b11:fifo_full=0;

	endcase
end
//generating valid out
assign vld_out_0 = ~empty_0;

assign vld_out_1 = ~empty_1;

assign vld_out_2 = ~empty_2;

//count_0 logic -- to count 30 clock cycles
 always@(posedge clock)
 begin
	 if(resetn==1'b0)
		 count_0<=5'd1;
	 else if(vld_out_0==1'b0)
		 count_0<=5'd1;
	 else if(read_enb_0)
		 count_0<=5'd1;
	 else if(count_0==5'd30)
		 count_0<=5'd1;
	else if(count_0!=30)
		count_0<=count_0+5'd1;
end


//soft_reset_0 logic 
always@(posedge clock)
begin
	if(resetn==1'b0)
		soft_reset_0<=1'b0;
	else if(vld_out_0==1'b0)
		soft_reset_0<=1'b0;
	else if(read_enb_0)
		soft_reset_0<=1'b0;
	else if(count_0 == 5'd30)
		soft_reset_0<=1'b1;
	else if(count_0!=30)
		soft_reset_0<=1'b0;
end

//count_1 logic
 always@(posedge clock)
 begin
	 if(resetn==1'b0)
		 count_1<=5'd1;
	 else if(vld_out_1==1'b0)
		 count_1<=5'd1;
	 else if(read_enb_1)
		 count_1<=5'd1;
	 else if(count_1==5'd30)
		 count_1<=5'd1;
		else if(count_1!=30)
			count_1<=count_1+5'd1;
end


//soft_reset_1 logic
always@(posedge clock)
begin
	if(resetn==1'b0)
		soft_reset_1<=1'b0;
	else if(vld_out_1==1'b0)
		soft_reset_1<=1'b0;
	else if(read_enb_1)
		soft_reset_1<=1'b0;
	else if(count_1 == 5'd30)
		soft_reset_1<=1'b1;
	else if(count_1!=30)
		soft_reset_1<=1'b0;
end

//count_2 logic
 always@(posedge clock)
 begin
	 if(resetn==1'b0)
		 count_2<=5'd1;
	 else if(vld_out_2==1'b0)
		 count_2<=5'd1;
	 else if(read_enb_2)
		 count_2<=5'd1;
	 else
		 if(count_2==5'd30)
		 count_2<=5'd1;
		else if(count_2!=30)
			count_2<=count_2+5'd1;
end


//soft_reset_2 logic
always@(posedge clock)
begin
	if(resetn==1'b0)
		soft_reset_2<=1'b0;
	else if(vld_out_2==1'b0)
		soft_reset_2<=1'b0;
	else if(read_enb_2)
		soft_reset_2<=1'b0;
	else if(count_2 == 5'd30)
		soft_reset_2<=1'b1;
	else if(count_2!=30)
		soft_reset_2<=1'b0;
end


endmodule






module router_fifo(input clock,resetn,write_enb,soft_reset,read_enb,lfd_state, output empty,full,
input [7:0]data_in,
output reg [7:0]data_out);
reg [6:0]count;
reg[4:0] rd_pt,write;//it is 5 bit because as 16 can be represented using 5 bits
reg [8:0] mem [15:0];
reg temp;
integer i,j;

always@(posedge clock)
begin
	if(!resetn)
	temp <= 1'b0;
	else 
	temp <= lfd_state;
end

//read logic
always@(posedge clock)
begin
	if(!resetn)
	begin
		data_out<=8'h0;
		rd_pt<=4'b0;
	//	count<=7'h0;
		end
	else if(soft_reset)
		data_out<=8'hz;
	/*else if(count==0 && data_out!=0)
		data_out<=8'hz;*/
	
	else if(read_enb && !empty)
	begin
		data_out<=mem[rd_pt[3:0]];
		rd_pt<=rd_pt+1;
	end
	end
//write logic
always@(posedge clock)
begin
	if(!resetn)	
	begin
		write<=8'h0;
		for(i=0;i<16;i=i+1)
			
				mem[i]<=0;
			
	end
	else if(soft_reset)
	begin
		write<=8'h0;
	
		for(j=0;j<16;j=j+1)
		begin
			mem[j]<=0;
		end	
	end

	else if(write_enb && !full)
	begin
		mem[write[3:0]]<={temp,data_in};
		write<=write+5'b1;
		end

end
always@(posedge clock)
begin
	if(!resetn)
		count<=7'h0;
	else if(soft_reset)
		count<=7'h0;
	else if(read_enb && !empty)
	begin
		if(mem[rd_pt[3:0]][8]==1'b1)
		count <= mem[rd_pt[3:0]][7:2]+5'h1;
		else if(count != 4'h0)
			count<=count-1;
		end
		end
assign full=((write == 5'd16)&&(rd_pt == 0));
assign empty=(write == rd_pt);
endmodule




module top;
 import router_pkg::*;
 import uvm_pkg::*;
 
 bit clock;
 always
  #5 clock=~clock;

  router_if s_if0(clock);
  router_if d_if0(clock);
  router_if d_if1(clock);
  router_if d_if2(clock);

  
	router_top DUV(.clock(clock),.resetn(s_if0.resetn),.pkt_valid(s_if0.pkt_valid),.error(s_if0.error),.busy(s_if0.busy),.data_in(s_if0.data_in),
			.data_out_0(d_if0.data_out),.data_out_1(d_if1.data_out),.data_out_2(d_if2.data_out),
			.valid_out_0(d_if0.valid_out),.valid_out_1(d_if1.valid_out),.valid_out_2(d_if2.valid_out),
			.read_enb_0(d_if0.read_enb),.read_enb_1(d_if1.read_enb),.read_enb_2(d_if2.read_enb));

  
 initial
   begin
     //setting s_if0,d_if0,d_if1,d_if3 in config_db
     uvm_config_db #(virtual router_if) :: set(null,"*","s_if0",s_if0);
     uvm_config_db #(virtual router_if) :: set(null,"*","d_if0",d_if0);
     uvm_config_db #(virtual router_if) :: set(null,"*","d_if1",d_if1);
     uvm_config_db #(virtual router_if) :: set(null,"*","d_if2",d_if2);
  
     run_test();
   end
//endmodule

     property stable_data;
       @(posedge clock) s_if0.busy |=> $stable(s_if0.data_in);
     endproperty

     property busy_check;
       @(posedge clock) $rose(s_if0.pkt_valid) |=> s_if0.busy;
     endproperty

     property valid_signal;
       @(posedge clock) $rose(s_if0.pkt_valid) |-> ##3(d_if0.valid_out|d_if1.valid_out|d_if2.valid_out);
     endproperty

     property read_enb1;
       @(posedge clock) d_if0.valid_out |-> ##[1:29]d_if0.read_enb;
     endproperty 

     property read_enb2;
       @(posedge clock) d_if1.valid_out |-> ##[1:29]d_if1.read_enb;
     endproperty 

     property read_enb3;
       @(posedge clock) d_if2.valid_out |-> ##[1:29]d_if2.read_enb;
     endproperty 

     property read_enb1_low;
       @(posedge clock) $fell(d_if0.valid_out)|-> $fell(d_if1.read_enb);
     endproperty 

     property read_enb2_low;
       @(posedge clock) $fell(d_if1.valid_out)|=> $fell(d_if2.read_enb);
     endproperty 
     
     property read_enb3_low;
       @(posedge clock) $fell(d_if2.valid_out)|=> $fell(d_if0.read_enb);
     endproperty 

     C1:assert property(stable_data)
          $display("stable data assertion is successfull");
     else 
          $display("stable data assertion failed");

     C2:assert property(busy_check)
          $display("busy_check assertion is successfull");
     else 
          $display("busy_check assertion failed");

     C3:assert property(valid_signal)
          $display("valid_signal assertion is successfull");
     else 
          $display("valid_signal assertion failed");

     C4:assert property(read_enb1)
          $display("read_enb1 assertion is successfull");
     else 
          $display("read_enb1 assertion failed");
    
     C5:assert property(read_enb2)
          $display("read_enb2 assertion is successfull");
     else 
          $display("read_enb2 assertion failed");

     C6:assert property(read_enb3)
          $display("read_enb3 assertion is successfull");
     else 
          $display("read_enb3 assertion failed");

     C7:assert property(read_enb1_low)
          $display("read_enb1_low assertion is successfull");
     else 
          $display("read_enb1_low assertion failed");

     C8:assert property(read_enb2_low)
          $display("read_enb2_low assertion is successfull");
     else 
          $display("read_enb2_low assertion failed");

     C9:assert property(read_enb3_low)
         $display("read_enb3_low assertion is successfull");
     else 
          $display("read_enb3_low assertion failed");

endmodule



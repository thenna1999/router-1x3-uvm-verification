interface router_if(input bit clk);
logic resetn,pkt_valid,error,busy,valid_out,read_enb;
logic[7:0]data_in,data_out;

//for source driver
clocking src_drv_cb@(posedge clk);
 default input #1 output #1;
 output data_in,pkt_valid,resetn;
 input busy;             //as when busy is low then only we are driving the data
endclocking

//for source monitor
clocking src_mon_cb@(posedge clk);
 default input #1 output #1;
	input data_in,pkt_valid,resetn,busy,error;
endclocking

//for destination driver
clocking dst_drv_cb@(posedge clk);
 default input #1 output #1;
 output read_enb;
 input valid_out;
endclocking

//clocking destination monitor
clocking dst_mon_cb@(posedge clk);
 default input #1 output #1;
 input data_out,read_enb,valid_out;
endclocking

modport SRC_DRV (clocking src_drv_cb);
modport SRC_MON (clocking src_mon_cb);
modport DST_DRV (clocking dst_drv_cb);
modport DST_MON (clocking dst_mon_cb);

endinterface


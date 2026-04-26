class ddriver extends uvm_driver #(dst_xtn);
 `uvm_component_utils(ddriver)

  virtual router_if.DST_DRV vif;

		
  destination_agt_config dst_cfg;

 function new(string name="ddriver",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  if(!uvm_config_db #(destination_agt_config)::get(this,"","destination_agt_config",dst_cfg))
   `uvm_fatal(get_full_name(),"cannot get uvm_config_db,have u set it()");
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=dst_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever
  begin
   seq_item_port.get_next_item(req);
	send_to_dut(req);
   //req.print();
   seq_item_port.item_done();
  end	
endtask


task send_to_dut(dst_xtn req);
`uvm_info("dest driver","printing from dest driver",UVM_LOW)
req.print();
	while(vif.dst_drv_cb.valid_out!==1)
		begin
		@(vif.dst_drv_cb);
		end
		repeat(req.no_of_cycles)
		@(vif.dst_drv_cb);
	
		vif.dst_drv_cb.read_enb<=1'b1;
			@(vif.dst_drv_cb);

	while(vif.dst_drv_cb.valid_out!==0)
		@(vif.dst_drv_cb);
		@(vif.dst_drv_cb);

	vif.dst_drv_cb.read_enb<=1'b0;
	

endtask
		


endclass


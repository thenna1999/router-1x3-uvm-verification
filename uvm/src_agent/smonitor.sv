class smonitor extends uvm_monitor;
 `uvm_component_utils(smonitor)
 
  virtual router_if.SRC_MON vif;

  source_agt_config src_cfg;
  uvm_analysis_port#(src_xtn)ap;

function new(string name="smonitor",uvm_component parent);
  super.new(name,parent);
  ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  if(!uvm_config_db #(source_agt_config)::get(this,"","source_agt_config",src_cfg))
   `uvm_fatal(get_full_name(),"cannot get uvm_config_db,have u set it()");
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=src_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
  forever
   collect_data();
endtask

task collect_data();
 	src_xtn xtn;
		xtn=src_xtn::type_id::create("xtn");
		while(vif.src_mon_cb.pkt_valid!==1)
			@(vif.src_mon_cb);
		while(vif.src_mon_cb.busy!==0)
			@(vif.src_mon_cb);
		xtn.header=vif.src_mon_cb.data_in;
		xtn.payload=new[xtn.header[7:2]];
	
		@(vif.src_mon_cb);
		foreach(xtn.payload[i])
			begin
			while(vif.src_mon_cb.busy!==0)
				@(vif.src_mon_cb);

				xtn.payload[i]=vif.src_mon_cb.data_in;
				@(vif.src_mon_cb);
			end
			while(vif.src_mon_cb.pkt_valid!==0)
				@(vif.src_mon_cb);

				xtn.parity=vif.src_mon_cb.data_in;
						@(vif.src_mon_cb);
				@(vif.src_mon_cb);
			xtn.error=vif.src_mon_cb.error;
`uvm_info("source monitor","printing form source monitor",UVM_LOW)
xtn.print();

			ap.write(xtn);
//`uvm_info("source monitor","printing form source monitor",UVM_LOW)
//	xtn.print();


endtask
 

endclass


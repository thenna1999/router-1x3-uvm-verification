class dmonitor extends uvm_monitor;
 `uvm_component_utils(dmonitor)

  virtual router_if.DST_MON vif;

  destination_agt_config dst_cfg;
  uvm_analysis_port#(dst_xtn)m_ap;

 function new(string name="dmonitor",uvm_component parent);
  super.new(name,parent);
  m_ap=new("m_ap",this);
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

   collect_data();
endtask

task collect_data();
 	dst_xtn xtn;
	xtn=dst_xtn::type_id::create("xtn");
	//	$display("1");	
	//	@(vif.dst_mon_cb);
//@(vif.dst_mon_cb);
//@(vif.dst_mon_cb);
//	@(vif.dst_mon_cb);
//@(vif.dst_mon_cb);

		while(vif.dst_mon_cb.read_enb!==1)
		@(vif.dst_mon_cb);
	@(vif.dst_mon_cb);
	xtn.header=vif.dst_mon_cb.data_out;
     //   $display("print after header %d",vif.dst_mon_cb.data_out);
	xtn.payload=new[xtn.header[7:2]];
	@(vif.dst_mon_cb);
	foreach(xtn.payload[i])
		begin
		xtn.payload[i]=vif.dst_mon_cb.data_out;
		@(vif.dst_mon_cb);
		end
		//	$display("2");		
	xtn.parity=vif.dst_mon_cb.data_out;
		//	$display("3");		
	while(vif.dst_mon_cb.read_enb!==0)
		@(vif.dst_mon_cb);
`uvm_info("dest monitor","printing from dest monitor",UVM_LOW)

	xtn.print();
       m_ap.write(xtn);
endtask
 


endclass


class sdriver extends uvm_driver #(src_xtn);
 `uvm_component_utils(sdriver)

  virtual router_if.SRC_DRV vif;
		
  source_agt_config src_cfg;


function new(string name="sdriver",uvm_component parent);
  super.new(name,parent);
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
@(vif.src_drv_cb);
 vif.src_drv_cb.resetn<=1'b0;
@(vif.src_drv_cb);
 vif.src_drv_cb.resetn<=1'b1;

 forever
  begin
   seq_item_port.get_next_item(req);
   send_to_dut(req);
   //req.print();
   seq_item_port.item_done();
  end	
endtask

task send_to_dut(src_xtn req);
`uvm_info("source driver","printing form source driver",UVM_LOW)
req.print();
  while(vif.src_drv_cb.busy!==0)
   begin
   @(vif.src_drv_cb);
   end
      vif.src_drv_cb.pkt_valid<=1'b1;
      vif.src_drv_cb.data_in<=req.header;
   @(vif.src_drv_cb);
    foreach(req.payload[i])
     begin
     while(vif.src_drv_cb.busy!==0)
            @(vif.src_drv_cb);
      vif.src_drv_cb.data_in<=req.payload[i];
      @(vif.src_drv_cb);
     end

     vif.src_drv_cb.pkt_valid<=1'b0;
     vif.src_drv_cb.data_in<=req.parity;
    
     repeat(2)
     @(vif.src_drv_cb);
endtask


endclass


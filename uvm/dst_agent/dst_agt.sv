class dst_agt extends uvm_agent;
 `uvm_component_utils(dst_agt)  
  
  ddriver drvh;
  dmonitor monh;
  dsequencer seqrh;

  destination_agt_config dst_cfg;

  function new(string name="dst_agt",uvm_component parent);
    super.new(name,parent);
  endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
   if(!uvm_config_db #(destination_agt_config)::get(this,"","destination_agt_config",dst_cfg))
    `uvm_fatal(get_full_name(),"cannot get dst config have u set it?");
   monh=dmonitor::type_id::create("monh",this);
   if(dst_cfg.is_active==UVM_ACTIVE)
    begin
    drvh=ddriver::type_id::create("drvh",this);
    seqrh=dsequencer::type_id::create("seqrh",this);
    end
endfunction

 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(dst_cfg.is_active==UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);
 endfunction
endclass



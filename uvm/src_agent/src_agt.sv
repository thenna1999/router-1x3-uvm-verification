class src_agt extends uvm_agent;
 `uvm_component_utils(src_agt)
  sdriver drvh;
  smonitor monh;
  ssequencer seqrh;
  source_agt_config src_cfg;
  function new(string name="src_agt",uvm_component parent);
    super.new(name,parent);
  endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
   if(!uvm_config_db #(source_agt_config)::get(this,"","source_agt_config",src_cfg))
    `uvm_fatal(get_full_name(),"cannot get src config have u set it?");
   monh=smonitor::type_id::create("monh",this);
   if (src_cfg.is_active==UVM_ACTIVE)
    begin
    drvh=sdriver::type_id::create("drvh",this);
    seqrh=ssequencer::type_id::create("seqrh",this);
    end
endfunction
 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(src_cfg.is_active==UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);
 endfunction
endclass



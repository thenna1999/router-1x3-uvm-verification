class source_agt_config extends uvm_object;
 `uvm_object_utils(source_agt_config);
  virtual router_if vif;
  uvm_active_passive_enum is_active=UVM_ACTIVE;

 //constructor new method
 function new(string name = "source_agt_config");
  super.new(name);
 endfunction

endclass


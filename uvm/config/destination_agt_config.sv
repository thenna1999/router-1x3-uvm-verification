class destination_agt_config extends uvm_object;
 `uvm_object_utils(destination_agt_config);
  virtual router_if vif;
  uvm_active_passive_enum is_active=UVM_ACTIVE;

 //constructor new method
 function new(string name = "destination_agt_config");
  super.new(name);
 endfunction
endclass


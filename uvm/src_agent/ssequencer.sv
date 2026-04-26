class ssequencer extends uvm_sequencer #(src_xtn);
 `uvm_component_utils(ssequencer)
  //virtual router_if vif;

function new(string name="ssequencer",uvm_component parent);
  super.new(name,parent);
endfunction

endclass

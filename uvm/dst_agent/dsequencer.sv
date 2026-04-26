class dsequencer extends uvm_sequencer #(dst_xtn);
 `uvm_component_utils(dsequencer)
  //virtual router_if vif;

function new(string name="dsequencer",uvm_component parent);
  super.new(name,parent);
endfunction
endclass


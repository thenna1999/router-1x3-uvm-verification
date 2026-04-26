
class env_config extends uvm_object;
 `uvm_object_utils(env_config)
  source_agt_config src_cfg[];           //as we can change in the future to 2*3.so we are declaring it as dynamic.
  destination_agt_config dst_cfg[];
  int no_of_src_agts=1;
  int no_of_dst_agts=3;
  bit has_src_agts=1;
  bit has_dst_agts=1;
  bit has_scoreboard=1;
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  extern function new(string name="env_config");
endclass

 //constructor new method
 function env_config:: new(string name = "env_config");
  super.new(name);
 endfunction




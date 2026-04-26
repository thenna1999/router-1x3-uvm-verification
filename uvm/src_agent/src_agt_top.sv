class src_agt_top extends uvm_env;
 `uvm_component_utils(src_agt_top)
  src_agt s_agt[];
  env_config e_cfg;
 // int no_of_src_agts;
 extern function new (string name="src_agt_top",uvm_component parent);
 extern function void build_phase(uvm_phase phase);
endclass

function src_agt_top::new(string name="src_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction

function void src_agt_top::build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
   `uvm_fatal(get_full_name(),"cannot get env config have u set() it?")
	
 //	if(e_cfg.has_src_agts)
 //	 begin
	 s_agt=new[e_cfg.no_of_src_agts];
	  foreach(s_agt[i])
         	begin
         	 s_agt[i]=src_agt::type_id::create($sformatf("s_agt[%0d]",i),this);
 	         uvm_config_db #(source_agt_config)::set(this,"*","source_agt_config",e_cfg.src_cfg[i]);

         	end
   // 	end
endfunction
 


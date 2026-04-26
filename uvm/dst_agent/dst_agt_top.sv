class dst_agt_top extends uvm_env;
 `uvm_component_utils(dst_agt_top)

  dst_agt d_agt[];

  env_config e_cfg;

  extern function new(string name="dst_agt_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function dst_agt_top::new(string name="dst_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction

function void dst_agt_top::build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
   `uvm_fatal(get_full_name(),"cannot get env config have u set() it?");
	
 	if(e_cfg.has_dst_agts)
 	 begin
	 d_agt=new[e_cfg.no_of_dst_agts];
	 
	  foreach(d_agt[i])
         	begin
         	 d_agt[i]=dst_agt::type_id::create($sformatf("d_agt[%0d]",i),this);
 	         uvm_config_db #(destination_agt_config)::set(this,$sformatf("d_agt[%0d]*",i),"destination_agt_config",e_cfg.dst_cfg[i]);

         	end
    	end
endfunction



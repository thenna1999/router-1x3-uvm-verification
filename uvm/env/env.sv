class env extends uvm_env;
 `uvm_component_utils(env)

//-----------------declare handles----------------//

src_agt_top sagt_top;
dst_agt_top dagt_top;
env_config e_cfg;

scoreboard sb;

extern function new(string name = "env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
 
endclass

//---------------------constructor new method---------------------// 
function env::new(string name="env",uvm_component parent);
 super.new(name,parent);
endfunction

//---------------------build phase method-----------------------//
function void env::build_phase(uvm_phase phase);      
    super.build_phase(phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
          `uvm_fatal("config_load","cannot_get_configuration ram_env_config from uvm_config_db.Have u set it?");
	
    if(e_cfg.has_src_agts)
      begin
       // uvm_config_db #(source_agt_config)::set(this,"*","source_agt_config",e_cfg.src_cfg);
        sagt_top=src_agt_top::type_id::create("sagt_top",this);
      end  

	 if(e_cfg.has_dst_agts)
      begin
       // uvm_config_db #(source_agt_config)::set(this,"*","source_agt_config",e_cfg.src_cfg);
        dagt_top=dst_agt_top::type_id::create("dagt_top",this);
      end  
//endfunction		
	
    	        
 /*   if(e_cfg.has_virtual_sequencer)
     begin
        v_sequencer=ram_virtual_sequencer::type_id::create("v_sequencer",this);
     end
endfunction*/

    if(e_cfg.has_scoreboard)
     begin
        sb=scoreboard::type_id::create("sb",this);
     end	   
endfunction

//---------------------connect phase method-----------------------//

function void env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	if(e_cfg.has_scoreboard)
		begin
			sagt_top.s_agt[0].monh.ap.connect(sb.src_fifo[0].analysis_export);
			dagt_top.d_agt[0].monh.m_ap.connect(sb.dst_fifo[0].analysis_export);
			dagt_top.d_agt[1].monh.m_ap.connect(sb.dst_fifo[1].analysis_export);
			dagt_top.d_agt[2].monh.m_ap.connect(sb.dst_fifo[2].analysis_export);

		end

  endfunction   
 


class test extends uvm_test;
 `uvm_component_utils(test)

//-------------declare handles----------//
env envh;
env_config e_cfg;
source_agt_config src_cfg[];
destination_agt_config dst_cfg[];

int no_of_src_agts=1;
int no_of_dst_agts=3;
int has_src_agts=1;
int has_dst_agts=1;

extern function new(string name="test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void config_router();
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

//-------------------constructor new method--------------------//

function test::new(string name="test",uvm_component parent);
 super.new(name,parent);
endfunction

//-------------------function config--------------------//
function void test::config_router();
 if(has_src_agts) 
   begin
     src_cfg=new[no_of_src_agts];
     foreach(src_cfg[i])
      begin
       src_cfg[i]=source_agt_config::type_id::create($sformatf("src_cfg[%0d]",i));
       if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("s_if%0d",i),src_cfg[i].vif))
         `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db.have u set() it?")
          src_cfg[i].is_active=UVM_ACTIVE;
          e_cfg.src_cfg[i]=src_cfg[i];
       end
    end

  if(has_dst_agts) 
   begin
     dst_cfg=new[no_of_dst_agts];
     foreach(dst_cfg[i])
      begin
       dst_cfg[i]=destination_agt_config::type_id::create($sformatf("dst_cfg[%0d]",i));
       if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("d_if%0d",i),dst_cfg[i].vif))
         `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db.have u set() it?")
          dst_cfg[i].is_active=UVM_ACTIVE;
          e_cfg.dst_cfg[i]=dst_cfg[i];
       end
    end
      
    e_cfg.has_src_agts=has_src_agts;
    e_cfg.has_dst_agts=has_dst_agts;
    e_cfg.no_of_src_agts=no_of_src_agts;
    e_cfg.no_of_dst_agts=no_of_dst_agts;



endfunction : config_router

//--------------------function build phase-------------------//
function void test::build_phase(uvm_phase phase);
  e_cfg=env_config::type_id::create("e_cfg");
  if(has_src_agts)
    e_cfg.src_cfg=new[no_of_src_agts];
  if(has_dst_agts)
    e_cfg.dst_cfg=new[no_of_dst_agts];
  config_router();
  uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
  super.build_phase(phase);
  envh=env::type_id::create("envh",this);
endfunction

function void test::end_of_elaboration_phase(uvm_phase phase);
 super.end_of_elaboration_phase(phase);
 uvm_top.print_topology;
endfunction

//-------------------for small_seq_test ------------------------//

class small_seq_test extends test;
 `uvm_component_utils(small_seq_test)
  small_pkt s_seq;
 normal_seq n_s_seq;
  bit [1:0] addr;
  
  function new (string name="small_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
  //repeat(2)
  // begin
   s_seq=small_pkt::type_id::create("s_seq");
   n_s_seq=normal_seq::type_id::create("n_s_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    repeat(8)
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     n_s_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
   // end
    #100;
    
    phase.drop_objection(this);
   
  endtask

endclass


class small_seq_test1 extends test;
 `uvm_component_utils(small_seq_test)
  small_pkt s_seq;
  other_seq o_s_seq;
  bit [1:0] addr;
  
  function new (string name="small_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
   s_seq=small_pkt::type_id::create("s_seq");
   o_s_seq=other_seq::type_id::create("o_s_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
   // repeat(5)
    begin
    repeat(8)
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     o_s_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
    #100;
    end
    phase.drop_objection(this);
  endtask

endclass

//-------------------for medium_seq_test ------------------------//

class medium_seq_test extends test;
 `uvm_component_utils(medium_seq_test)
  medium_pkt s_seq;
  normal_seq n_m_seq;
  bit [1:0] addr;
  
  function new (string name="medium_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
   s_seq=medium_pkt::type_id::create("s_seq");
   n_m_seq=normal_seq::type_id::create("n_m_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    repeat(8)
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     n_m_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
    #100;
    phase.drop_objection(this);
  endtask

endclass

class medium_seq_test1 extends test;
 `uvm_component_utils(medium_seq_test)
  medium_pkt s_seq;
  other_seq o_m_seq;
  bit [1:0] addr;
  
  function new (string name="medium_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
   s_seq=medium_pkt::type_id::create("s_seq");
   o_m_seq=other_seq::type_id::create("o_m_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    repeat(8)	
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     o_m_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
    #100;
    phase.drop_objection(this);
  endtask

endclass


//-------------------for large_seq_test ------------------------//

class large_seq_test extends test;
 `uvm_component_utils(large_seq_test)
  large_pkt s_seq;
  normal_seq n_l_seq;
  bit [1:0] addr;
  
  function new (string name="large_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
   s_seq=large_pkt::type_id::create("s_seq");
   n_l_seq=normal_seq::type_id::create("n_l_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
   // repeat(2)
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     n_l_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
    #100;
    phase.drop_objection(this);
  endtask

endclass

class large_seq_test1 extends test;
 `uvm_component_utils(large_seq_test)
  large_pkt s_seq;
  other_seq o_l_seq;
  bit [1:0] addr;
  
  function new (string name="large_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
   s_seq=large_pkt::type_id::create("s_seq");
   o_l_seq=other_seq::type_id::create("o_l_seq");

   addr=$urandom%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
  
    fork
     s_seq.start(envh.sagt_top.s_agt[0].seqrh);
     o_l_seq.start(envh.dagt_top.d_agt[addr].seqrh);
    join
    #100;
    phase.drop_objection(this);
  endtask

endclass





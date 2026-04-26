class sseq_base extends uvm_sequence #(src_xtn);
 `uvm_object_utils(sseq_base)

function new(string name="sseq_base");
  super.new(name);
endfunction

endclass

//-------------------for small_packet------------------------//

class small_pkt extends sseq_base;
 `uvm_object_utils(small_pkt)
  bit[1:0]addr;

function new(string name="small_pkt");
 super.new(name);
endfunction

task body();
 // repeat(2)
   begin
     req=src_xtn::type_id::create("req");
     if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {header[7:2]<14;
                                  header[1:0]==addr;});
 //	`uvm_info("small_seq",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask

endclass

//-------------------for medium_packet----	--------------------//

class medium_pkt extends sseq_base;
 `uvm_object_utils(medium_pkt)
  bit[1:0]addr;

function new(string name="medium_pkt");
 super.new(name);
endfunction

task body();
 // repeat(2)
   begin
     req=src_xtn::type_id::create("req");
     if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {header[7:2] inside{[14:40]};
                                  header[1:0]==addr;});
 //	`uvm_info("medium_seq",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask

endclass


//-------------------for large_packet------------------------//

class large_pkt extends sseq_base;
 `uvm_object_utils(large_pkt)
  bit[1:0]addr;

function new(string name="large_pkt");
 super.new(name);
endfunction

task body();
// repeat(2)
   begin
     req=src_xtn::type_id::create("req");
     if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {header[7:2]>40;
                                  header[1:0]==addr;});
 //	`uvm_info("RAM_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask

endclass

/*
//-------------------for bad_packet------------------------//

function small_packet extends sseq_base;
 `uvm_object_utils(small_packet)
  bit[1:0]addr;

function new::(string name="small packet");
 super.new(name);
endfunction

task body();
  repeat(2)
   begin
     req=src_xtn::type_id::create("req");
     (!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {header[7:2]<14;
                                  header[1:0]==addr;});
 	`uvm_info("RAM_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask
*/


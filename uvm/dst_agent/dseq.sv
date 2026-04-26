class dseq_base extends uvm_sequence #(dst_xtn);
 `uvm_object_utils(dseq_base)

function new(string name="dseq_base");
  super.new(name);
endfunction

endclass

//-------------------for small_packet------------------------//

class normal_seq extends dseq_base;
 `uvm_object_utils(normal_seq)
  //bit[1:0]addr;

function new(string name="normal_seq");
 super.new(name);
endfunction

task body();
 //repeat(2)
   begin
     req=dst_xtn::type_id::create("req");
 //    if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
//        `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {no_of_cycles inside{[1:29]};})
 //	`uvm_info("small_seq",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask

endclass

//-------------------for medium_packet----	--------------------//

class other_seq extends dseq_base;
 `uvm_object_utils(other_seq)
 // bit[1:0]addr;

function new(string name="other_seq");
 super.new(name);
endfunction

task body();
  //repeat(2)
   begin
     req=dst_xtn::type_id::create("req");
  //   if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
     //   `uvm_fatal(get_full_name(),"cannot get uvm_config_db have u set it?");
     start_item(req);
     assert(req.randomize() with {no_of_cycles<30;})
 //	`uvm_info("medium_seq",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
     finish_item(req);
   end
endtask

endclass





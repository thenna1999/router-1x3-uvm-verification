class src_xtn extends uvm_sequence_item;
 `uvm_object_utils(src_xtn)
  rand bit[7:0]header;
  rand bit[7:0]payload[];
  bit [7:0] parity;
  bit error;
  constraint c1{header[1:0]!=2'b11;	
                header[7:2]!=0;}
  constraint c2{payload.size==header[7:2];}

  function new(string name="src_xtn");
   super.new(name);
  endfunction
 
  function void do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		bitstream value     size       radix for printing
    printer.print_field( "header", 		this.header, 	    8,		 UVM_DEC		);
  //  printer.print_field("payload_size",this.header[7:2],$size(header[7:2]),UVM_DEC);
   // printer.print_field("address",this.header[1:0],$size(header[1:0]),UVM_DEC);

    foreach(payload[i])
     begin
      printer.print_field( $sformatf("payload[%0d]",i), this.payload[i], 	   8,		 UVM_DEC		);
     end
    printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
    printer.print_field( "error", 		this.error, 	    1,		 UVM_DEC		);

  endfunction:do_print

  function void post_randomize();
    parity=header;
    foreach(payload[i])
      parity=parity^payload[i];
  endfunction

  
endclass


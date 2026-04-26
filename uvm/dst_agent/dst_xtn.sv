class dst_xtn extends uvm_sequence_item;
 `uvm_object_utils(dst_xtn)
  bit[7:0]header;
  bit[7:0]payload[];
  bit [7:0] parity;
  rand bit [5:0]no_of_cycles;

  function new(string name="src_xtn");
   super.new(name);
  endfunction
 
  function void do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		bitstream value     size       radix for printing
   	printer.print_field("header",this.header,8,UVM_DEC);
              foreach(payload[i])
		begin
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
		end
              printer.print_field("parity",this.parity,8,UVM_DEC);
            // printer.print_field("packet_size",this.header[7:2],$size(header[7:2]),UVM_DEC);
	    // printer.print_field("address",this.header[1:0],$size(header[1:0]),UVM_DEC);
	      printer.print_field("no_of_cycles",this.no_of_cycles,6,UVM_DEC);

  endfunction:do_print

 /* function void post_randomize();
    parity=header;
    foreach(payload[i])
      parity=parity^payload[i];
  endfunction
*/

 endclass


class scoreboard extends uvm_scoreboard;
 `uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(src_xtn) src_fifo[];
	uvm_tlm_analysis_fifo #(dst_xtn) dst_fifo[];
    
	src_xtn src_data;
	dst_xtn dst_data;

        env_config e_cfg;

function new(string name="scoreboard",uvm_component parent);
 super.new(name,parent);
  
 src_cvg=new();
 dst_cvg=new();

endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
          `uvm_fatal("config_load","cannot_get_configuration env_config from uvm_config_db.Have u set it?");

  	src_fifo=new[e_cfg.no_of_src_agts];
  	dst_fifo=new[e_cfg.no_of_dst_agts];

        foreach(src_fifo[i])
              src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);
        foreach(dst_fifo[i])
              dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);

endfunction

covergroup src_cvg;
    	ADDR_SRC: coverpoint src_data.header[1:0]{
				bins addr1={2'b00};}
				//bins addr2=2'b01;
 				//bins addr3=2'b10;}
	PAYLOAD_LENGTH_SRC : coverpoint src_data.header[7:2]{
				bins small_pkt={[1:15]};
                                bins medium_pkt={[16:40]};
				bins large_pkt={[41:63]};}
	ERROR_SRC : coverpoint src_data.error{
				bins no_error={0};
				bins error={1};}
	CROSS_SRC : cross ADDR_SRC,PAYLOAD_LENGTH_SRC,ERROR_SRC;
endgroup

covergroup dst_cvg;
    	ADDR_DST: coverpoint dst_data.header[1:0]{
				bins addr1={2'b00};
				bins addr2={2'b01};
 				bins addr3={2'b10};}
	PAYLOAD_LENGTH_DST : coverpoint dst_data.header[7:2]{
				bins small_pkt={[1:15]};
                                bins medium_pkt={[16:40]};
				bins large_pkt={[41:63]};}
	CROSS_DST : cross ADDR_DST,PAYLOAD_LENGTH_DST;
endgroup


task run_phase(uvm_phase phase);
 super.run_phase(phase);
  forever 
    begin
      fork
        begin
          src_fifo[0].get(src_data);
          src_data.print();
          src_cvg.sample();
        end
        begin
          fork
            begin
              dst_fifo[0].get(dst_data);
              dst_data.print();
              dst_cvg.sample();
            end
            begin
              dst_fifo[1].get(dst_data);
              dst_data.print();
              dst_cvg.sample();
            end
            begin
              dst_fifo[2].get(dst_data);
              dst_data.print();
              dst_cvg.sample();
            end
          join_any
          disable fork;
       end
            join
compare_data(src_data,dst_data);
   end
endtask

task compare_data(src_xtn src_data,dst_xtn dst_data);
   if(src_data.header==dst_data.header)
      $display("header matched successfully");
   else 
      $display("header mismatched::::src_header=%0d,dst_header=%0d",src_data.header,dst_data.header);
  if(src_data.payload==dst_data.payload)
      $display("payload matched successfully");
   else 
      $display("payload mismatched::::src_payload=%0p,dst_payload=%0p",src_data.payload,dst_data.payload);
  if(src_data.parity==dst_data.parity)
      $display("parity matched successfully");
   else 
      $display("parity mismatched::::src_parity=%0d,dst_parity=%0d",src_data.parity,dst_data.parity);
endtask




endclass
	



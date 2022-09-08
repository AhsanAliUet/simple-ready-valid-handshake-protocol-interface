
module tb_val_ready_fsm ();

   parameter DW = 8;    //This is local variable of tb
   logic clk_i;
   logic rst_i;

   logic ready_i;
   logic valid_i;

   logic ready_o;
   logic valid_o;

   logic [DW-1:0] data_in;
   logic [DW-1:0] data_out;

   initial begin
      clk_i = 0;
      forever #5 clk_i = ~clk_i;
   end

   //module instatiation
   val_ready_fsm #(.DW(DW)) 
   val_ready_dut (clk_i, 
                  rst_i, 
                  ready_i, 
                  valid_i, 
                  ready_o, 
                  valid_o, 
                  data_in, 
                  data_out
   );

   initial begin
          rst_i = 1;
          data_in = 'd5;
      #6; rst_i = 0;
      #5; ready_i = 1;
      #5; ready_i = 0;
      #5; ready_i = 1;
      #5; data_in = 'd10;
      #5; $stop;
   end

   initial begin
      $dumpfile("val_ready_fsm_dumpfile.vcd");
      $dumpvars(0, tb_val_ready_fsm);
   end

endmodule
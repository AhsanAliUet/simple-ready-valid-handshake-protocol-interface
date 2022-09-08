
//This module implements FSM of a simple ready-valid interface to 
//Communicate between two devices
module val_ready_fsm #(
   parameter DW = 32
)(
   input clk_i,
   input rst_i,

   input ready_i,
   input valid_i,             //Not used for now

   output logic ready_o,     //Not used for now
   output logic valid_o,

   input [DW-1:0] data_in,
   output logic [DW-1:0] data_out

);
parameter IDLE = 2'b00, WAIT_VALID = 2'b01;
parameter WAIT_READY = 2'b10, TRANSFER = 2'b11;

logic [1:0] state;
logic [1:0] next_state;

//for time being, data is always valid
//If data is not valid sometimes, we will make it zero in some another logic making it zero
//Like our data cannot be less than 7, if it is, then turn valid to 0
logic valid = 1'b1; 

always_ff @( posedge clk_i, posedge rst_i ) begin : state_changing_on_clk
   if (rst_i) begin
      state <= IDLE;
      valid_o <= valid;      //This is just a simpe handshake          
   end else begin
      state <= next_state;
   end

end

always_comb begin : change_based_on_input
   if          (ready_i == 0 && valid == 0) begin
      next_state <= IDLE;

   end else if (ready_i == 1 && valid == 0) begin
      next_state <= WAIT_VALID;

   end else if (ready_i == 0 && valid == 1) begin
      next_state <= WAIT_READY;

   end else if (ready_i == 1 && valid == 1) begin
      next_state <= TRANSFER;
   end
end

always_comb begin : output_decision_based_on_state
   
   if (state != TRANSFER) begin
      data_out <= '0;
   end else begin
      data_out <= data_in;
   end
end
endmodule
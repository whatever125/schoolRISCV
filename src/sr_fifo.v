
module fifo
#(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 3
)
(
    input clk,
    input reset,
    input write_enable,
    input [DATA_WIDTH-1:0] write_data,
    input read_enable,
    output reg [DATA_WIDTH-1:0] read_data,
);
    parameter DEPTH = 2 ** ADDR_WIDTH;
    
    reg [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] write_ptr = 0;
    reg [ADDR_WIDTH-1:0] read_ptr = 0;
    reg full;
    reg empty;
    
    initial begin
        write_ptr <= 0;
        read_ptr <= 0;
        read_data <= 0;
        full <= 0;
        empty <= 1;
    end
    
    always @(posedge clk or negedge reset) begin
        // Reset all regs
        if (!reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            read_data <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            // Write data to FIFO
            if (write_valid && !read_valid && !full) begin
                fifo_mem[write_ptr] <= write_data;
                write_ptr <= (write_ptr + 1) % DEPTH;
                empty <= 0;
                
                if ((write_ptr + 1) % DEPTH == read_ptr) begin
                    full <= 1;
                end
            end
            
            // Read data from FIFO
            if (read_valid && !write_valid && !empty) begin
                read_data <= fifo_mem[read_ptr];
                read_ptr <= (read_ptr + 1) % DEPTH;
                full <= 0;
                
                if ((read_ptr + 1) % DEPTH == write_ptr) begin
                    empty <= 1;
                end
            end
        end
    end
endmodule

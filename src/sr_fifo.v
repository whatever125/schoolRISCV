
module fifo
#(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 3
)
(
    input clk,
    input reset,
    input writeEnable,
    input [DATA_WIDTH-1:0] writeData,
    input readEnable,
    output reg [DATA_WIDTH-1:0] readData
);
    parameter DEPTH = 2 ** ADDR_WIDTH;
    
    reg [DATA_WIDTH-1:0] fifoMem [DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] writePtr = 0;
    reg [ADDR_WIDTH-1:0] readPtr = 0;
    reg full = 0;
    reg empty = 1;
    
    always @(posedge clk or negedge reset) begin
        // Reset all regs
        if (!reset) begin
            writePtr <= 0;
            readPtr <= 0;
            readData <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            // Write data to FIFO
            if (writeEnable && !readEnable && !full) begin
                fifoMem[writePtr] <= writeData;
                writePtr <= (writePtr + 1) % DEPTH;
                empty <= 0;
                
                if ((writePtr + 1) % DEPTH == readPtr) begin
                    full <= 1;
                end
            end
            
            // Read data from FIFO
            if (readEnable && !writeEnable && !empty) begin
                readData <= fifoMem[readPtr];
                readPtr <= (readPtr + 1) % DEPTH;
                full <= 0;
                
                if ((readPtr + 1) % DEPTH == writePtr) begin
                    empty <= 1;
                end
            end
        end
    end
endmodule

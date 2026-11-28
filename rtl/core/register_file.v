module register_file(
    input clk,reg_write,
    input  [4:0] rs1,rs2,rd,
    input  [31:0] write_data,
    output  [31:0] read_data1,read_data2
);
reg [31:0] regs [0:31];
integer i;
initial begin for(i=0;i<32;i=i+1) begin regs[i]=0;end end


always @(posedge clk)
    begin 
        if(reg_write && rd!=0)begin
            regs[rd]<=write_data;
        end
    end

assign read_data1= (rs1!=0)?regs[rs1]:32'b0;
assign read_data2= (rs2!=0)?regs[rs2]:32'b0;

endmodule
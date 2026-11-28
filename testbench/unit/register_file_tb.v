module register_file_tb;
reg  clk,reg_write;
reg  [31:0] write_data;
reg  [4:0]  rd,rs1,rs2;
wire [31:0] read_data1,read_data2; 
integer i;
integer pass_count=0,fail_count=0;

register_file uut(.clk(clk),.reg_write(reg_write),.write_data(write_data),.rd(rd),.rs1(rs1),.rs2(rs2),
                  .read_data1(read_data1),.read_data2(read_data2));

initial clk=0;
always #5 clk=~clk;


task write_reg(
    input [4:0] addr,
    input [31:0] data,
    input we
    );
begin 
@(negedge clk)begin
rd=addr;write_data=data;reg_write=we;end
@(posedge clk)# 1;
begin
reg_write=0;end
end
endtask

task check_read(
    input [4:0]a1,a2,
    input [31:0]exp1,exp2,
    input [12*8-1:0] name
);

    rs1=a1;rs2=a2;
    #1;
    if(read_data1===exp1 && read_data2===exp2)begin
    pass_count=pass_count+1;
    end
    else begin
    fail_count=fail_count+1;
    $display("Fail:%0s rs1:%h rs2:%h",name,a1,a2);
    $display("want rd1:%h rd2:%h",read_data1,read_data2);
    $display("got rd1:%h rd2:%h",exp1,exp2);
    end
    endtask



    initial begin 
    $dumpfile("simulation/waveforms/register_file.vcd");
    $dumpvars(0, register_file_tb);

reg_write = 0; write_data = 0; rd = 0; rs1 = 0; rs2 = 0;
        @(posedge clk); #1;

        // 1. write x5, read it back on port 1
        write_reg(5'd5, 32'hDEADBEEF, 1);
        check_read(5'd5, 5'd0, 32'hDEADBEEF, 32'h0, "write/read");

        // 2. write to x0 must be ignored
        write_reg(5'd0, 32'hFFFFFFFF, 1);
        check_read(5'd0, 5'd0, 32'h0, 32'h0, "x0 stays 0");

        // 3. reg_write = 0 must not change anything
        write_reg(5'd6, 32'h11111111, 1);
        write_reg(5'd6, 32'h22222222, 0);
        check_read(5'd6, 5'd0, 32'h11111111, 32'h0, "no write en");

        // 4. two different registers read at once
        write_reg(5'd1, 32'h11111111, 1);
        write_reg(5'd2, 32'h22222222, 1);
        check_read(5'd1, 5'd2, 32'h11111111, 32'h22222222, "two ports");

        // 5. same register on both ports
        check_read(5'd5, 5'd5, 32'hDEADBEEF, 32'hDEADBEEF, "same reg");

        // 6. write x1..x31 with unique values, read all back (both ports)
        for (i = 1; i < 32; i = i + 1)
            write_reg(i, 32'h10000000 + i, 1);
        for (i = 1; i < 32; i = i + 1)
            check_read(i, 32 - i, 32'h10000000 + i, 32'h10000000 + (32 - i), "all regs");

        // 7. overwrite a register
        write_reg(5'd7, 32'hAAAAAAAA, 1);
        write_reg(5'd7, 32'h55555555, 1);
        check_read(5'd7, 5'd0, 32'h55555555, 32'h0, "overwrite");

        // 8. read and write the same register in the same cycle:
        //    the read must return the OLD value, the new value appears after the edge
        @(negedge clk);
        rd = 5'd9; write_data = 32'hBBBBBBBB; reg_write = 1;
        check_read(5'd9, 5'd0, 32'h10000009, 32'h0, "old value");
        @(posedge clk); #1;
        reg_write = 0;
        check_read(5'd9, 5'd0, 32'hBBBBBBBB, 32'h0, "new value");

        // 9. x0 still reads zero after everything above
        check_read(5'd0, 5'd0, 32'h0, 32'h0, "x0 final");

        $display("=========================================================");
        $display("Passed:%0d    failed:%0d", pass_count, fail_count);
        if (fail_count == 0) $display("ALL TESTCASES PASSED");
        $finish;
    end
endmodule
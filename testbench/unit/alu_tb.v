module  alu_tb;
    reg  [31:0] a,b;
    reg  [3:0]operator;
    wire [31:0] y;
    wire ze_fg,ca_fg,ov_fg,ng_fg;
    integer pass_count=0;
    integer fail_count=0;
alu uut(.a(a),.b(b),.operator(operator),.y(y),.ze_fg(ze_fg),.ov_fg(ov_fg),.ca_fg(ca_fg),.ng_fg(ng_fg));


task check(
    input  [3:0] op,
    input  [31:0] in_a,in_b,
    input  [31:0] exp_y,
    input   exp_ze, exp_ng, exp_ov, exp_ca,
    input  [12*8-1:0] name
);
begin
a=in_a;b=in_b;operator=op;
#5;
if (y===exp_y && ze_fg===exp_ze && ca_fg===exp_ca && ov_fg===exp_ov && ng_fg===exp_ng)
begin pass_count=pass_count+1; end
else
begin 
fail_count=fail_count+1;
$display("FAIL %0s:a=%h b=%h ",name,in_a,in_b);
$display("got  y=%h z=%b c=%b o=%b n=%b ", y, ze_fg, ca_fg, ov_fg, ng_fg);
$display("want y=%h z=%b c=%b o=%b n=%b ", exp_y, exp_ze, exp_ca, exp_ov, exp_ng);
end
end
endtask

initial begin 
$dumpfile("alu.vcd");
$dumpvars(0,alu_tb);



 //            op           a          b          exp_y      ze ng ov ca  name
        // ADD
        check(4'b0000, 32'd10,       32'd20,      32'd30,       0,0,0,0, "add");
        check(4'b0000, 32'hFFFFFFFF, 32'd1,       32'd0,        1,0,0,1, "add carry");
        check(4'b0000, 32'h7FFFFFFF, 32'd1,       32'h80000000, 0,1,1,0, "add ovf+");
        check(4'b0000, 32'h80000000, 32'h80000000,32'd0,        1,0,1,1, "add ovf-");
        // SUB
        check(4'b0001, 32'd20,       32'd10,      32'd10,       0,0,0,0, "sub");
        check(4'b0001, 32'd5,        32'd7,       32'hFFFFFFFE, 0,1,0,1, "sub borrow");
        check(4'b0001, 32'd7,        32'd7,       32'd0,        1,0,0,0, "sub zero");
        check(4'b0001, 32'h80000000, 32'd1,       32'h7FFFFFFF, 0,0,1,0, "sub ovf");
        // Logic
        check(4'b0010, 32'hF0F0,     32'h0FF0,    32'h00F0,     0,0,0,0, "and");
        check(4'b0011, 32'hF0F0,     32'h0FF0,    32'hFFF0,     0,0,0,0, "or");
        check(4'b0100, 32'hF0F0,     32'h0FF0,    32'hFF00,     0,0,0,0, "xor");
        check(4'b0100, 32'hABCD1234, 32'hABCD1234,32'd0,        1,0,0,0, "xor same");
        // Shifts (shift amount uses b[4:0] only)
        check(4'b0101, 32'd1,        32'd4,       32'd16,       0,0,0,0, "sll");
        check(4'b0101, 32'd1,        32'd32,      32'd1,        0,0,0,0, "sll by 32");
        check(4'b0110, 32'h80000000, 32'd4,       32'h08000000, 0,0,0,0, "srl");
        check(4'b0111, 32'h80000000, 32'd4,       32'hF8000000, 0,1,0,0, "sra neg");
        check(4'b0111, 32'h40000000, 32'd4,       32'h04000000, 0,0,0,0, "sra pos");
        // Comparisons
        check(4'b1000, 32'hFFFFFFFF, 32'd1,       32'd1,        0,0,0,0, "slt -1<1");
        check(4'b1000, 32'd1,        32'hFFFFFFFF,32'd0,        1,0,0,0, "slt 1<-1");
        check(4'b1001, 32'hFFFFFFFF, 32'd1,       32'd0,        1,0,0,0, "sltu big");
        check(4'b1001, 32'd1,        32'hFFFFFFFF,32'd1,        0,0,0,0, "sltu small");
        // Unused opcode
        check(4'b1111, 32'd123,      32'd456,     32'd0,        1,0,0,0, "default");

    $display("=========================================================================");
    $display("Passed:%0d    failed:%0d",pass_count,fail_count);
    if(fail_count==0) $display("ALL TESTCASES PASSED");
    $finish;
end
endmodule
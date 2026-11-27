module alu(
    input [31:0] a,b,
    input  [3:0]operator,
    output reg ze_fg,ng_fg,ov_fg,ca_fg,
    output reg [31:0] y
);
reg [32:0] temp;
always @(*)
begin
ze_fg=0;
ng_fg=0;
ov_fg=0;
ca_fg=0;
y=0;
temp=0;
case (operator)
    4'b0000:begin 
            temp={1'b0,a}+{1'b0,b};y=temp[31:0];
            if(temp[32]==1)begin ca_fg=1; end
            if((a[31]==b[31])&(a[31]!=y[31]))
            begin ov_fg=1; end
            end
    4'b0001:begin temp={1'b0,a}-{1'b0,b};y=temp[31:0];
            if(temp[32]==1)begin ca_fg=1; end
            if((a[31]!=b[31])&(a[31]!=y[31]))
            begin ov_fg=1; end
             end
    4'b0010:begin y=a&b; end
    4'b0011:begin y=a|b; end
    4'b0100:begin y=a^b; end
    4'b0101:begin y=a<<b[4:0]; end
    4'b0110:begin y=a>>b[4:0]; end
    4'b0111:begin y=$signed(a)>>>b[4:0]; end
    4'b1000:begin y=$signed(a)<$signed(b); end
    4'b1001:begin y=a<b; end
    default:begin y=0 ; end
endcase

if(y[31]==1)begin ng_fg=1; end
if(y==0)begin ze_fg=1; end
end
endmodule
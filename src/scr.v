`timescale 1ns / 1ps

module scr(
    input clk,
    input Pmedio, Parriba, Pabajo, Pizquierda, Pderecha,
    output [7:0] Num
    );

    reg [7:0] Estado = 8'd128;
    reg [26:0] X = 27'd0;
    wire [26:0] Fx;
    wire Cx;
    
    always @(posedge clk)
        X <= Fx;

    // Bloque combinacional de X

    assign Fx = (Cx) ? 27'd0 : X + 27'd1;
    assign Cx = ((Pizquierda|Pderecha)&(~Parriba)&(~Pabajo)) ? (X > 27'd49_999_998) :(X == 27'd99_999_999);

    always @(posedge clk)
    begin
        if (Cx)
        begin
            if (Pmedio==1)
                Estado <= 8'd128;
            else if ((Parriba)&(Pabajo))
                Estado <= Estado;
            else if (Parriba)
                Estado <= Estado + 8'd12;
            else if (Pabajo)
                Estado <= Estado - 8'd12;
            else if ((Pderecha)&(Pizquierda))
                Estado <= Estado;
            else if (Pderecha)
                Estado <= Estado + 8'd5;
            else if (Pizquierda)
                Estado <= Estado - 8'd5;
            else
                Estado <= Estado;
        end
    end
   assign Num = Estado;
endmodule



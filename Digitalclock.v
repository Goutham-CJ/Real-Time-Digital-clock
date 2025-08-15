module clockDivider #(parameter FREQ = 500000000)(input clk,rst, output reg clkDiv);
    reg [31:0] count;
    always@(posedge clk) begin
        if(rst) begin
            count <= 0;
            clkDiv <= 0;
        end
        else begin
        if(count == (FREQ-1)/2) begin
            count <= 0;
            clkDiv <= ~clkDiv;
        end
        else begin
            count <= count + 1;

        end
        end
    end 
endmodule

module digitalClock(output reg [3:0] sec1,sec2,min1,min2,hour1,hour2,input clk,rst,format,set,up,down,input [2:0] select);
    integer max_hour1, max_hour2;
    
    always @(posedge clk) begin
        
        if(rst) begin
            sec1 <= 0;
            sec2 <= 0;
            min1 <= 0;
            min2 <= 0; 
            hour1 <= 0;
            hour2 <= 0;
        end
        else begin
        if(~set) begin 
        if(format) begin
            max_hour1 = 2;
            max_hour2 = 1;
        end
        else begin
            max_hour1 = 3;
            max_hour2 = 2;
        end
        
        if(sec1 < 9) begin
            sec1 <= sec1 + 1;
        end else begin
            sec1 <= 0;
            if(sec2 < 5) begin
                sec2 <= sec2 + 1;
            end else begin
                sec2 <= 0;
                if(min1 < 9) begin
                    min1 <= min1 + 1;
                end else begin
                    min1 <= 0;
                    if(min2 < 5) begin
                        min2 <= min2 + 1;
                    end else begin
                        min2 <= 0;
                        if(hour1 < max_hour1) begin
                            hour1 <= hour1 + 1;
                        end else begin
                            hour1 <= 0;
                            if(hour2 < max_hour2) begin
                                hour2 <= hour2 + 1;
                            end else begin
                                hour2 <= 0;
                            end
                        end
                    end
                end
            end
        end
        end

        else begin
            case(select)
                3'b000: begin
                    if(up) sec1 <= sec1 + 1;
                    else if(down) sec1 <= sec1 - 1;
                end
                3'b001: begin
                    if(up) sec2 <= sec2 + 1;
                    else if(down) sec2 <= sec2 - 1;
                end
                3'b010: begin
                    if(up) min1 <= min1 + 1;
                    else if(down) min1 <= min1 - 1;
                end
                3'b011: begin
                    if(up) min2 <= min2 + 1;
                    else if(down) min2 <= min2 - 1;
                end
                3'b100: begin
                    if(up) begin
                        if(hour1 < max_hour1) hour1 <= hour1 + 1; end
                    else if(down) hour1 <= hour1 - 1;
                end
                3'b101: begin
                    if(up) begin
                        if(hour2 < max_hour2) hour2 <= hour2 + 1; end
                    else if(down) hour2 <= hour2 - 1;
                end
                default:;
            endcase
            end
        end

    end

endmodule

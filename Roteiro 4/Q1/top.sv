// Roberto Pereira dos Santos Filho - 121210587
// Roteiro 4 - Questão 1

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    //SEG <= SWI;
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

    logic serial;
    logic reset;
    logic selecao;
    logic [3:0] entrada_paralela;
    logic [3:0] saida;

    always_comb begin
        serial <= SWI[0];
        reset <= SWI[1];
        selecao <= SWI[2];
        entrada_paralela[3:0] <= SWI[7:4];
    end

    always_ff @(posedge clk_2) begin

        if (reset) begin
            saida[3:0] <= 'b0000;
            SEG[7:0] <= 'b00000000;
        end
        else begin
            if (selecao == 0)
                saida[3:0] <= entrada_paralela[3:0];
            else begin
                saida[3] <= serial;
                saida[2] <= saida[3];
                saida[1] <= saida[2];
                saida[0] <= saida[1];
            end
        end

        LED[7:4] <= saida[3:0];

        case (saida)
            0: SEG[7:0] <= 'b00111111;
            1: SEG[7:0] <= 'b00000110;
            2: SEG[7:0] <= 'b01011011;
            3: SEG[7:0] <= 'b01001111;
            4: SEG[7:0] <= 'b01100110;
            5: SEG[7:0] <= 'b01101101;
            6: SEG[7:0] <= 'b01111101;
            7: SEG[7:0] <= 'b00000111;
            8: SEG[7:0] <= 'b01111111;
            9: SEG[7:0] <= 'b01101111;
            10: SEG[7:0] <= 'b01110111;
            11: SEG[7:0] <= 'b01111111;
            12: SEG[7:0] <= 'b00111001;
            13: SEG[7:0] <= 'b00111111;
            14: SEG[7:0] <= 'b01111001;
            15: SEG[7:0] <= 'b01110001;
        endcase
    end

    always_comb LED[0] <= clk_2;
endmodule

// Roberto Pereira dos Santos Filho - 121210587
// Roteiro 5 - Questão 1

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

  parameter zero = 'b00111111;
  parameter um = 'b00000110;
  parameter dois = 'b01011011;
  parameter tres = 'b01001111;
  parameter quatro = 'b01100110;
  parameter cinco = 'b01101101;
  parameter seis = 'b01111101;
  parameter sete = 'b00000111;
  parameter oito = 'b01111111;
  parameter nove = 'b01101111;
  parameter dez = 'b01110111;
  parameter onze = 'b01111111;
  parameter doze = 'b00111001;
  parameter treze = 'b00111111;
  parameter quatorze = 'b01111001;
  parameter quinze = 'b01110001;


  logic reset;
  logic selecao;
  logic [3:0] entrada;
  logic [3:0] saida;

  always_comb begin
    reset <= SWI[0];
    selecao <= SWI[1];
    entrada[3:0] <= SWI[7:4];
  end

  always_ff @(posedge clk_2) begin

    if (reset) saida <= 0;
    else begin
      saida <= entrada;
      if (selecao) begin
        if (saida == 15) saida <= entrada;
        else saida <= saida + 1;
      end
      else begin
        if (saida == 0) saida <= entrada;
        else saida <= saida - 1;
      end
    end
    
    LED[7:4] <= saida;

    case (saida)
      0: SEG[7:0] <= zero;
      1: SEG[7:0] <= um;
      2: SEG[7:0] <= dois;
      3: SEG[7:0] <= tres;
      4: SEG[7:0] <= quatro;
      5: SEG[7:0] <= cinco;
      6: SEG[7:0] <= seis;
      7: SEG[7:0] <= sete;
      8: SEG[7:0] <= oito;
      9: SEG[7:0] <= nove;
      10: SEG[7:0] <= dez;
      11: SEG[7:0] <= onze;
      12: SEG[7:0] <= doze;
      13: SEG[7:0] <= treze;
      14: SEG[7:0] <= quatorze;
      15: SEG[7:0] <= quinze;
    endcase
  end

  always_comb LED[0] <= clk_2;
endmodule

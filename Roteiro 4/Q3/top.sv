// Roberto Pereira dos Santos Filho - 121210587
// Roteiro 4 - Questão 3

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

  parameter cinco = 'b01101101;
  parameter seis = 'b01111101;
  parameter nove = 'b01101111;
  parameter doze = 'b00111001;


  parameter Lzero = 'b0000;
  parameter Lcinco = 'b0101;
  parameter Lseis = 'b0110;
  parameter Lnove = 'b1001;
  parameter Ldoze = 'b1100;

  
  logic reset;
  logic [1:0] entrada;

  always_comb begin
        reset <= SWI[0];
        entrada[1:0] <= SWI[3:2];
  end

  always_ff @(posedge clk_2) begin

    
    if (reset) begin
      LED[7:4] <= Lzero;
      SEG[7:0] <= 'b00000000;
    end
    else begin
      case(entrada[1:0])
        'b00: begin
          SEG[7:0] <= seis;
          LED[7:4] <= Lseis;
        end
        'b01:begin
          SEG[7:0] <= doze;
          LED[7:4] <= Ldoze;
        end
        'b10:begin
          SEG[7:0] <= nove;
          LED[7:4] <= Lnove;
        end
        'b11:begin
          SEG[7:0] <= cinco;
          LED[7:4] <= Lcinco;
        end
      endcase
    end
  end

  always_comb LED[0] <= clk_2;
endmodule

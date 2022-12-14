module dds_pulse
#( parameter PHASE_W = 32, parameter DATA_W = 12, parameter TABLE_AW = 12
)( input [PHASE_W - 1 : 0] FreqWord, input [PHASE_W - 1 : 0] PhaseShift,
   input Clock, input ClkEn, output  reg signed[DATA_W - 1 : 0] Out
) ;
   reg signed [DATA_W - 1 : 0] sinTable[2 ** TABLE_AW - 1 : 0]; // Sine table ROM
   reg [PHASE_W - 1 : 0] phase; // Phase Accumulater
   wire [PHASE_W - 1 : 0] addr = phase + PhaseShift; // Phase Shift
   initial begin
      phase = 0;
      $readmemh("F:/VivadoProj/HardWareProj/YingJianKeShe/Sawooth.dat", sinTable); // Initialize the ROM
   end
   always@(posedge Clock) begin
      if(ClkEn) phase <= phase + FreqWord;
      else phase<=0;
   end
   always@(posedge Clock) begin
      Out <= sinTable[addr[PHASE_W - 1 : PHASE_W - TABLE_AW]]; // Look up the table
   end
endmodule

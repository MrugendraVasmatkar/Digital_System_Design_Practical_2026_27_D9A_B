`timescale 1ns/1ps
module Game_Score_Categorizer (Score, START, ACK, Clock, Reset,
                               LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT);
  input [3:0] Score;
  input START, ACK, Clock, Reset;
  output LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT;
  reg LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT;

  parameter IDLE = 3'b000, LOW = 3'b001, MEDIUM = 3'b010, HIGH = 3'b011, EXCELLENT = 3'b100;
  reg [2:0] Moore_State;
  reg [3:0] Score_Reg;

  wire Is_Low, Is_Medium, Is_High, Is_Excellent;

  assign Is_Low       = (Score_Reg <= 4'd4);
  assign Is_Medium    = (Score_Reg >= 4'd5)  & (Score_Reg <= 4'd8);
  assign Is_High      = (Score_Reg >= 4'd9)  & (Score_Reg <= 4'd12);
  assign Is_Excellent = (Score_Reg >= 4'd13);

  always
    @ (posedge Clock)
      if (Reset)
        Score_Reg <= 4'b0000;
      else if (Moore_State == IDLE)
        Score_Reg <= Score;
      else
        Score_Reg <= Score_Reg;

  always
    @ (posedge Clock)
      if (Reset)
        Moore_State <= IDLE;
      else
        case (Moore_State)
          IDLE :
            begin
              if (START)
                begin
                  if (Is_Low)
                    Moore_State <= LOW;
                  else if (Is_Medium)
                    Moore_State <= MEDIUM;
                  else if (Is_High)
                    Moore_State <= HIGH;
                  else
                    Moore_State <= EXCELLENT;
                end
              else
                Moore_State <= IDLE;
            end

          LOW :
            begin
              if (ACK)
                Moore_State <= IDLE;
              else
                Moore_State <= LOW;
            end

          MEDIUM :
            begin
              if (ACK)
                Moore_State <= IDLE;
              else
                Moore_State <= MEDIUM;
            end

          HIGH :
            begin
              if (ACK)
                Moore_State <= IDLE;
              else
                Moore_State <= HIGH;
            end

          EXCELLENT :
            begin
              if (ACK)
                Moore_State <= IDLE;
              else
                Moore_State <= EXCELLENT;
            end

          default :
            begin
              Moore_State <= IDLE;
            end
        endcase

  always
    @ (Moore_State)
      case (Moore_State)
        IDLE :
          begin
            LED_LOW = 0;
            LED_MEDIUM = 0;
            LED_HIGH = 0;
            LED_EXCELLENT = 0;
          end

        LOW :
          begin
            LED_LOW = 1;
            LED_MEDIUM = 0;
            LED_HIGH = 0;
            LED_EXCELLENT = 0;
          end

        MEDIUM :
          begin
            LED_LOW = 0;
            LED_MEDIUM = 1;
            LED_HIGH = 0;
            LED_EXCELLENT = 0;
          end

        HIGH :
          begin
            LED_LOW = 0;
            LED_MEDIUM = 0;
            LED_HIGH = 1;
            LED_EXCELLENT = 0;
          end

        EXCELLENT :
          begin
            LED_LOW = 0;
            LED_MEDIUM = 0;
            LED_HIGH = 0;
            LED_EXCELLENT = 1;
          end

        default :
          begin
            LED_LOW = 0;
            LED_MEDIUM = 0;
            LED_HIGH = 0;
            LED_EXCELLENT = 0;
          end
      endcase

endmodule

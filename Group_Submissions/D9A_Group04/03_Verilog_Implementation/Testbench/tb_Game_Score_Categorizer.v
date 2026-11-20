`timescale 1ns/1ps
module tb_Game_Score_Categorizer;
  reg [3:0] Score = 4'd0;
  reg START = 0, ACK = 0, Clock = 0, Reset = 1;
  wire LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT;
  wire [2:0] State;
  reg [2:0] exp_state;
  integer errors = 0, tests = 0, s;

  Game_Score_Categorizer dut (.Score(Score), .START(START), .ACK(ACK), .Clock(Clock), .Reset(Reset),
                              .LED_LOW(LED_LOW), .LED_MEDIUM(LED_MEDIUM), .LED_HIGH(LED_HIGH),
                              .LED_EXCELLENT(LED_EXCELLENT));

  assign State = dut.Moore_State;

  always #5 Clock = ~Clock;

  function [2:0] category;
    input [3:0] v;
    begin
      if (v <= 4)       category = 3'b001;
      else if (v <= 8)  category = 3'b010;
      else if (v <= 12) category = 3'b011;
      else              category = 3'b100;
    end
  endfunction

  function [8*9:1] name;
    input [2:0] st;
    begin
      case (st)
        3'b000 : name = "IDLE";
        3'b001 : name = "LOW";
        3'b010 : name = "MEDIUM";
        3'b011 : name = "HIGH";
        3'b100 : name = "EXCELLENT";
        default: name = "INVALID";
      endcase
    end
  endfunction

  task check;
    input [8*40:1] what;
    begin
      tests = tests + 1;
      if (State !== exp_state ||
          LED_LOW !== (exp_state == 3'b001) || LED_MEDIUM !== (exp_state == 3'b010) ||
          LED_HIGH !== (exp_state == 3'b011) || LED_EXCELLENT !== (exp_state == 3'b100)) begin
        errors = errors + 1;
        $display("FAIL  %0s | Score=%0d state=%0s expected=%0s LEDs G=%b Y=%b R=%b B=%b",
                 what, Score, name(State), name(exp_state), LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT);
      end else
        $display("PASS  %0s | Score=%2d state=%b (%0s) LEDs G=%b Y=%b R=%b B=%b",
                 what, Score, State, name(State), LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT);
    end
  endtask

  task tick;
    begin
      @(posedge Clock); #1;
    end
  endtask

  initial begin
    $dumpfile("game_score.vcd");
    $dumpvars(0, tb_Game_Score_Categorizer);

    $display("=== T01 Reset ===");
    tick; tick;
    exp_state = 3'b000; check("reset -> IDLE");
    Reset = 0;

    $display("=== T02 IDLE holds without START ===");
    Score = 4'd9; tick; tick;
    check("no START, stay IDLE");

    $display("=== T03 ACK in IDLE has no effect ===");
    ACK = 1; tick; ACK = 0;
    check("ACK in IDLE");

    $display("=== T04 All 16 scores: START, hold, ignore switches, ACK ===");
    for (s = 0; s < 16; s = s + 1) begin
      Score = s; tick;
      START = 1; tick; START = 0;
      exp_state = category(s); check("START -> category");
      Score = ~s; tick; tick;
      check("switches changed, result held");
      START = 1; tick; START = 0;
      check("START again ignored");
      ACK = 1; tick; ACK = 0;
      exp_state = 3'b000; check("ACK -> IDLE");
    end

    $display("=== T05 START held for many clocks ===");
    Score = 4'd13; tick;
    START = 1; tick; tick; tick; tick;
    exp_state = 3'b100; check("START held, stays EXCELLENT");
    START = 0;
    ACK = 1; tick; ACK = 0;
    exp_state = 3'b000; check("ACK -> IDLE");

    $display("=== T06 START and ACK together ===");
    Score = 4'd6; tick;
    START = 1; ACK = 1; tick;
    exp_state = 3'b010; check("IDLE: START wins, ACK ignored");
    tick;
    exp_state = 3'b000; check("MEDIUM: ACK returns to IDLE");
    START = 0; ACK = 0; tick;

    $display("=== T07 RESET from every category state ===");
    for (s = 0; s < 16; s = s + 4) begin
      Score = s + 1; tick;
      START = 1; tick; START = 0;
      exp_state = category(s + 1); check("enter state");
      Reset = 1; tick; Reset = 0;
      exp_state = 3'b000; check("RESET -> IDLE");
    end

    $display("=== T08 Boundary scores ===");
    for (s = 0; s < 16; s = s + 1) begin
      if (s == 4 || s == 5 || s == 8 || s == 9 || s == 12 || s == 13) begin
        Score = s; tick;
        START = 1; tick; START = 0;
        exp_state = category(s); check("boundary");
        ACK = 1; tick; ACK = 0;
        exp_state = 3'b000;
      end
    end

    $display("==================================================");
    $display("TOTAL CHECKS = %0d   PASSED = %0d   FAILED = %0d", tests, tests - errors, errors);
    if (errors == 0) $display("RESULT: ALL TESTS PASSED");
    else             $display("RESULT: SOME TESTS FAILED");
    $display("==================================================");
    $finish;
  end
endmodule

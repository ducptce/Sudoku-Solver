// Code your testbench here
// or browse Examples
// Code your design here
`timescale 1ns/1ps
`define GRID_SIZE 9

class sudoku;
  
  int unsigned unsolved_puzzle[`GRID_SIZE][`GRID_SIZE];
  rand int unsigned solved_puzzle[`GRID_SIZE][`GRID_SIZE];
  rand int unsigned solved_puzzle_transpose[`GRID_SIZE][`GRID_SIZE];
  rand int unsigned solved_puzzle_box[`GRID_SIZE][`GRID_SIZE];
  
  constraint basic_c {
    foreach(solved_puzzle[row, col]) {
      solved_puzzle[row][col] inside {[1:9]};
      
      if (unsolved_puzzle[row][col] != 0) {
        solved_puzzle[row][col] == unsolved_puzzle[row][col];
      }
    }
    }
  constraint row_c {     
    foreach (solved_puzzle[row]) {
     	unique {solved_puzzle[row]};
        }
        }
  constraint col_c {
    foreach(solved_puzzle[row, col]) {
      solved_puzzle_transpose[row][col] == solved_puzzle[col][row];
    }
      foreach (solved_puzzle_transpose[row]) {
        unique {solved_puzzle_transpose[row]};
      }
     }
  constraint box_c {
    foreach (solved_puzzle[row,col]) {
      solved_puzzle_box[row][col] == solved_puzzle[(row/3)*3 + col/3][(row%3)*3+col%3];          }
		
      foreach (solved_puzzle_box[row]){
             unique {solved_puzzle_box[row]};}
  }    
                   
  function void sudokuSolver(int unsigned puzzle[`GRID_SIZE][`GRID_SIZE]);
    unsolved_puzzle = puzzle;
    this.randomize();
          
          $display("unsolved_puzzle: ", unsolved_puzzle);
    sudokuPrinter(unsolved_puzzle);
    
          $display("solved_puzzle: ", solved_puzzle);     
    sudokuPrinter(solved_puzzle);
  endfunction: sudokuSolver
    
  function void sudokuPrinter(int unsigned puzzle[`GRID_SIZE][`GRID_SIZE]);
    string hor_border = "-------------------------------------";
    string ver_border = "|";
    
    $display("%0s", hor_border);
    
    for(int row = 0; row < `GRID_SIZE; row++) begin
      string line = ver_border;
      for (int col = 0; col < `GRID_SIZE; col++) begin
        line = {line, " ", $sformatf("%0d", puzzle[row][col]), " |"};
         end
     		$display("%0s", line);
            $display("%0s", hor_border);
         end
  endfunction : sudokuPrinter                                                          
    
endclass : sudoku
    
module Sudoku;
  int unsigned puzzle[`GRID_SIZE][`GRID_SIZE];
  
  sudoku sudo; 
  
  initial begin
    // 0 means blank
    puzzle = '{ '{ 4,7,3, 5,2,0, 8,0,0 },
               '{ 0,0,0, 7,0,0, 0,4,0 },
               '{ 0,5,0, 4,0,9, 0,0,6 },
               '{ 0,0,5, 0,0,2, 0,0,9 },
               '{ 7,0,0, 9,0,0, 1,0,0 },
               '{ 2,1,0, 0,0,0, 5,0,8 },
               '{ 0,0,0, 2,0,7, 0,1,3 },
               '{ 3,0,0, 0,9,5, 6,8,0 },
               '{ 0,0,7, 8,0,0, 0,0,0 } };
               
    sudo = new();
    sudo.sudokuSolver(puzzle);
  end             
endmodule
               
               

module data_forward_unit(
                        WriteReg_ex_mem,  WriteReg_mem_wb,
                        MemRead_ex_mem,
                        Rs_id_ex, Rs_valid_id_ex, 
                        Rt_id_ex, Rt_valid_id_ex, 
                        Rd_ex_mem, Rd_valid_ex_mem, 
                        Rd_mem_wb, Rd_valid_mem_wb,
                        Rs_ex_mem, Rs_valid_ex_mem,
                        //Outputs
                        forwardA, forwardB 
                        );
   
  input [2:0] Rd_ex_mem, Rd_mem_wb, Rs_id_ex, Rt_id_ex, Rs_ex_mem;
  input WriteReg_ex_mem, WriteReg_mem_wb, MemRead_ex_mem;
  input Rs_valid_id_ex, Rt_valid_id_ex, Rd_valid_ex_mem, Rd_valid_mem_wb, Rs_valid_ex_mem; 
  
  output [1:0] forwardA, forwardB;

  //Execute hazard
  wire Rs_ex_hazard, Rt_ex_hazard;
  assign Rs_ex_hazard = (WriteReg_ex_mem & (Rs_id_ex == Rd_ex_mem) & Rs_valid_id_ex & Rd_valid_ex_mem) ? 1 : 0;
  assign Rt_ex_hazard = (WriteReg_ex_mem & (Rt_id_ex == Rd_ex_mem) & Rt_valid_id_ex & Rd_valid_ex_mem) ? 1 : 0;
   
  //Mem hazard
  wire Rs_mem_hazard, Rt_mem_hazard;
  assign Rs_mem_hazard = (WriteReg_mem_wb & (Rs_id_ex == Rd_mem_wb) & Rs_valid_id_ex & Rd_valid_mem_wb) ? 1 : 0;
  assign Rt_mem_hazard = (WriteReg_mem_wb & (Rt_id_ex == Rd_mem_wb) & Rt_valid_id_ex & Rd_valid_mem_wb) ? 1 : 0;

//  assign forwardA = (Rs_ex_hazard) ? 2'b10 : (Rs_mem_hazard) ? 2'b01 : 2'b00;

  assign load_ex_mem = (MemRead_ex_mem & WriteReg_ex_mem & Rs_valid_ex_mem & (Rs_id_ex == Rs_ex_mem)) ? 1 : 0;
  //for load -> forward 2'b11
  assign forwardA = (load_ex_mem)? 2'b11 : (Rs_ex_hazard) ? 2'b10 : (Rs_mem_hazard) ? 2'b01 : 2'b00;
  assign forwardB = (Rt_ex_hazard) ? 2'b10 : (Rt_mem_hazard) ? 2'b01 : 2'b00;

endmodule

module hazard_detection_unit(
                            MemRead_id_ex, 
                            Rt_id_ex, Rs_if_id, Rt_if_id,
                            Rt_valid_id_ex, Rs_valid_if_id, Rt_valid_if_id,

                            PCWrite, IF_ID_Write, zero_control_signals
                            );
  
  //LOAD USE HAZARD DETECTION SIGNALS//
  input MemRead_id_ex;
  input [2:0] Rt_id_ex, Rs_if_id, Rt_if_id;
  input Rt_valid_id_ex, Rs_valid_if_id, Rt_valid_if_id;
  
  output PCWrite; // used to stop pc from changing
  output IF_ID_Write; //used to prevent if_id reg from updating
  output zero_control_signals; //used to zero the desired control signals
  //END - LOAD USE HAZARD DETECTION SIGNALS//
  
  assign loadUse = MemRead_id_ex && 
                   (((Rt_id_ex == Rs_if_id) & Rt_valid_id_ex & Rs_valid_if_id) || 
                    ((Rt_id_ex == Rt_if_id) & Rt_valid_id_ex & Rt_valid_if_id));

  assign PCWrite              = (loadUse) ? 1'b0 : 1'b1;
  assign IF_ID_Write          = (loadUse) ? 1'b0 : 1'b1;
  assign zero_control_signals = (loadUse) ? 1'b1 : 1'b0;


endmodule

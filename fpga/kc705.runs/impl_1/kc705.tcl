proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param tcl.collectionResultDisplayLimit 0
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7k325tffg900-2
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir G:/fei/chester0536/kc705/fpga/kc705.cache/wt [current_project]
  set_property parent.project_path G:/fei/chester0536/kc705/fpga/kc705.xpr [current_project]
  set_property ip_output_repo G:/fei/chester0536/kc705/fpga/kc705.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet G:/fei/chester0536/kc705/fpga/kc705.runs/synth_1/kc705.dcp
  read_ip -quiet G:/fei/chester0536/kc705/fpga/HDL/xillybus/vivado-essentials/fifo_8x2048/fifo_8x2048.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/HDL/xillybus/vivado-essentials/fifo_8x2048/fifo_8x2048.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/clk1/coregen_sysclk.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/clk1/coregen_sysclk.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/HDL/xillybus/vivado-essentials/pcie_k7_vivado/pcie_k7_vivado.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/HDL/xillybus/vivado-essentials/pcie_k7_vivado/pcie_k7_vivado.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/mem1/coregen_user_mem8.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/mem1/coregen_user_mem8.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/mem2/coregen_buffer_mem16.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/mem2/coregen_buffer_mem16.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/mem3/coregen_mem8_chipaddr.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/mem3/coregen_mem8_chipaddr.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/fifo1/coregen_clk_crossing_fifo32.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/fifo1/coregen_clk_crossing_fifo32.xci]
  read_ip -quiet G:/fei/chester0536/kc705/fpga/IP_Core/fifo2/coregen_clk2M_crossing_fifo.xci
  set_property is_locked true [get_files G:/fei/chester0536/kc705/fpga/IP_Core/fifo2/coregen_clk2M_crossing_fifo.xci]
  set_property edif_extra_search_paths G:/fei/chester0536/kc705/fpga/HDL/xillybus/core [current_fileset]
  read_edif G:/fei/chester0536/kc705/fpga/HDL/adc/CPS_ReadOut_TOP.edf
  read_xdc G:/fei/chester0536/kc705/fpga/HDL/xillybus/vivado-essentials/xillydemo.xdc
  read_xdc G:/fei/chester0536/kc705/fpga/HDL/adc/CPS_ReadOut_TOP.xdc
  read_xdc G:/fei/chester0536/kc705/fpga/kc705.xdc
  link_design -top kc705 -part xc7k325tffg900-2
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force kc705_opt.dcp
  catch { report_drc -file kc705_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force kc705_placed.dcp
  catch { report_io -file kc705_io_placed.rpt }
  catch { report_utilization -file kc705_utilization_placed.rpt -pb kc705_utilization_placed.pb }
  catch { report_control_sets -verbose -file kc705_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step phys_opt_design
set ACTIVE_STEP phys_opt_design
set rc [catch {
  create_msg_db phys_opt_design.pb
  phys_opt_design 
  write_checkpoint -force kc705_physopt.dcp
  close_msg_db -file phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed phys_opt_design
  return -code error $RESULT
} else {
  end_step phys_opt_design
  unset ACTIVE_STEP 
}

  set_msg_config -source 4 -id {Route 35-39} -severity "critical warning" -new_severity warning
start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force kc705_routed.dcp
  catch { report_drc -file kc705_drc_routed.rpt -pb kc705_drc_routed.pb -rpx kc705_drc_routed.rpx }
  catch { report_methodology -file kc705_methodology_drc_routed.rpt -rpx kc705_methodology_drc_routed.rpx }
  catch { report_power -file kc705_power_routed.rpt -pb kc705_power_summary_routed.pb -rpx kc705_power_routed.rpx }
  catch { report_route_status -file kc705_route_status.rpt -pb kc705_route_status.pb }
  catch { report_clock_utilization -file kc705_clock_utilization_routed.rpt }
  catch { report_timing_summary -max_paths 10 -file kc705_timing_summary_routed.rpt -rpx kc705_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force kc705_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step post_route_phys_opt_design
set ACTIVE_STEP post_route_phys_opt_design
set rc [catch {
  create_msg_db post_route_phys_opt_design.pb
  phys_opt_design 
  write_checkpoint -force kc705_postroute_physopt.dcp
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file kc705_timing_summary_postroute_physopted.rpt -rpx kc705_timing_summary_postroute_physopted.rpx }
  close_msg_db -file post_route_phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed post_route_phys_opt_design
  return -code error $RESULT
} else {
  end_step post_route_phys_opt_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force kc705.mmi }
  write_bitstream -force kc705.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx kc705.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}


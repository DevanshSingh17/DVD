
# Part C: Static Timing Analysis using OpenSTA

set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Read the standard-cell timing library
read_liberty $lib

# Read and link the synthesized netlist
read_verilog synth/mult_array_netlist.v
link_design mult_array

# Define a 10 ns clock
create_clock -name clk -period 3.552 [get_ports clk]

# Input and output timing constraints
set_input_delay 1.0 -clock clk [delete_from_list [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]

# Report worst setup slack
report_worst_slack -max

# Save the critical-path timing report
report_checks -path_delay max -digits 3 > sta/mult_array_timing.rpt

####################################################
## CLOCK (100 MHz)
####################################################
set_property PACKAGE_PIN W5 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports clock]
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports clock]

####################################################
## PUSH BUTTONS
####################################################
# Reset → Middle Button (BTNC)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Transmit → Left Button (BTNL)
set_property PACKAGE_PIN T18 [get_ports transmit]
set_property IOSTANDARD LVCMOS33 [get_ports transmit]

####################################################
## SLIDE SWITCHES (in[7:0])
####################################################
set_property PACKAGE_PIN V17 [get_ports {in[0]}]
set_property PACKAGE_PIN V16 [get_ports {in[1]}]
set_property PACKAGE_PIN W16 [get_ports {in[2]}]
set_property PACKAGE_PIN W17 [get_ports {in[3]}]
set_property PACKAGE_PIN W15 [get_ports {in[4]}]
set_property PACKAGE_PIN V15 [get_ports {in[5]}]
set_property PACKAGE_PIN W14 [get_ports {in[6]}]
set_property PACKAGE_PIN W13 [get_ports {in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {in[*]}]

####################################################
## UART INTERFACE (USB-UART)
####################################################
# RX → PC to FPGA
set_property PACKAGE_PIN B18 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

# TX → FPGA to PC
set_property PACKAGE_PIN A18 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

####################################################
## LEDs (led[7:0])
####################################################
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

####################################################
## HEARTBEAT LED
####################################################
# LED15
set_property PACKAGE_PIN R17 [get_ports heartbeat]
set_property IOSTANDARD LVCMOS33 [get_ports heartbeat]

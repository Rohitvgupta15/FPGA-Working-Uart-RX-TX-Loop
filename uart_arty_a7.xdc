## Digilent Arty A7-100T (xc7a100tcsg324-1) - UART echo

## Clock 100 MHz
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock]
create_clock -name sys_clk -period 10.00 -waveform {0 5} [get_ports clock]

## Reset -> BTN0 (active-high)
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports reset]

## USB-UART
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS33} [get_ports rx]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports tx]

## led[3:0] -> LD4..LD7 (green LEDs)
set_property -dict {PACKAGE_PIN H5  IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN J5  IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {led[3]}]

## led[7:4] -> green channel of RGB LEDs LD0..LD3
set_property -dict {PACKAGE_PIN F6  IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN J4  IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN J2  IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN H6  IOSTANDARD LVCMOS33} [get_ports {led[7]}]

## Heartbeat -> blue channel of RGB LD0
set_property -dict {PACKAGE_PIN E1  IOSTANDARD LVCMOS33} [get_ports heartbeat]

## Bitstream settings
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

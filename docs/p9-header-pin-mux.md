PIN | USE | ZCZ BALL | OFFSET | PIN NAME | MODE 0 | MODE 1 | MODE 2 | MODE 3 | MODE 4 | MODE 5 | MODE 6 | MODE 7
:---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---:
1 |  |  |  | GND |  |  |  |  |  |  |  | 
2 |  |  |  | GND |  |  |  |  |  |  |  | 
3 |  |  |  | DC_3.3V |  |  |  |  |  |  |  | 
4 |  |  |  | DC_3.3V |  |  |  |  |  |  |  | 
5 |  |  |  | VDD_5V |  |  |  |  |  |  |  | 
6 |  |  |  | VDD_5V |  |  |  |  |  |  |  | 
7 |  |  |  | SYS_5V |  |  |  |  |  |  |  | 
8 |  |  |  | SYS_5V |  |  |  |  |  |  |  | 
9 | PWR |  |  | PWR_BUT |  |  |  |  |  |  |  | 
10 | RESET |  |  | SYS_RESETn |  |  |  |  |  |  |  | 
11 |  | T17 | 0x70 | GPMC_WAIT0 | gpmc_wait0 | gmii2_crs | gpmc_csn4 | rmii2_crs_dv | mmc1_sdcd | pr1_mii1_col | uart4_rxd | gpio0[30]
12 |  | U18 | 0x78 | GPMC_BE1n | gpmc_be1n | gmii2_col | gpmc_csn6 | mmc2_dat3 | gpmc_dir | pr1_mii1_rxlink | mcasp0_aclkr | gpio1[28]
13 |  | U17 | 0x74 | GPMC_Wpn | gpmc_wpn | gmii2_rxerr | gpmc_csn5 | rmii2_rxerr | mmc2_sdcd | pr1_mii1_txen | uart4_txd | gpio0[31]
14 |  | U14 | 0x48 | GPMC_A2 | gpmc_a2 | gmii2_txd3 | rgmii2_td3 | mmc2_dat1 | gpmc_a18 | pr1_mii1_txd2 | errpwm1A | gpio1[18]
15A |  | T13 | 0x88 | GPMC_CSn3 | gpmc_csn3 | gpmc_a3 | rmii2_crs_dv | mmc2_cmd | pr1_mii0_crs | pr1_mdio_data | EMU4 | gpio2[0]
15B |  | R13 | 0x40 | GPMC_A0 | gpmc_a0 | gmii2_txen | rmii2_tctl | mii2_txen | gpmc_a16 | pr1_mii_mt1_clk | ehrpwm1_tripzone_input | gpio1[16]
16 |  | T14 | 0x4c | GPMC_A3 | gpmc_a3 | gmii2_txd2 | rgmii2_td2 | mmc2_dat2 | gpmc_a19 | pr1_mii1_txd1 | ehrpwm1B | gpio1[19]
17 |  | A16 | 0x15c | SPI0_CS0 | spi0_cs0 | mmc2_sdwp | i2c1_scl | ehrpwm0_synci | pr1_uart0_txd | pr1_edio_data_in1 | pr1_edio_data_out1 | gpio0[5]
18 |  | B16 | 0x158 | SPI0_D1 | spi0_d1 | mmc1_sdwp | i2c1_sda | ehrpwm0_tripzone_input | pr1_uart0_rxd | pr1_edio_data_in0 | pr1_edio_data_out0 | gpio0[4]
19 |  | D17 | 0x17c | UART1_RTSn | uart1_rtsn | timer5 | dcan0_rx | i2c2_scl | spi1_cs1 | pr1_uart0_rts_n | pr1_edc_latch1_in | gpio0[13]
20 |  | D18 | 0x178 | UART1_CTSn | uart1_ctsn | timer6 | dcan0_tx | i2c2_sda | spi1_cs0 | pr1_uart0_cts_n | pr1_edc_latch0_in | gpio0[12]
21 |  | B17 | 0x154 | SPI0_D0 | spi0_d0 | uart2_txd | i2c2_scl | ehrpwm0B | pr1_uart0_rts_n | pr1_edio_latch_in | emu3 | gpio0[3]
22 |  | A17 | 0x150 | SPI0_SCLK | spi0_sclk | uart2_rxd | i2c2_sda | ehrpwm0A | pr1_uart0_cts_n | pr1_edio_sof | emu2 | gpio0[2]
23 |  | V14 | 0x044 | GPMC_A1 | gpmc_a1 | gmii2_rxdv | rgmii2_rctl | mmc2_dat0 | gpmc_a17 | pr1_mii1_txd3 | ehrpwm0_synco | gpio1[17]
24 |  | D15 | 0x184 | UART1_TXD | uart1_txd | mmc2_sdwp | dcan1_rx | i2c1_scl |  | pr1_uart0_txd | pr1_pru0_pru_r31_16 | gpio0[15]
25 |  | A14 | 0x1ac | MCASP0_AHCLKX | mcasp0_ahclkx | eqep0_strobe | mcasp0_axr3 | mcasp1_axr1 | emu4 | pr1_pru0_pru_r30_7 | pr1_pru0_pru_r31_7 | gpio3[21]
26 |  | D16 | 0x180 | UART1_RXD | uart1_rxd | mmc1_sdwp | dcan1_tx | i2c1_sda |  | pr1_uart0_rxd | pr1_pru1_pru_r31_16 | gpio0[14]
27 |  | C13 | 0x1a4 | MCASP0_FSR | mcasp0_fsr | eqep0b_in | mcasp0_axr3 | mcasp1_fsx | emu2 | pr1_pru0_pru_r30_5 | pr1_pru0_pru_r31_5 | gpio3[19]
28 |  | C12 | 0x19c | MCASP0_AHCLKR | mcasp0_ahclkr | ehrpwm0_synci | mcasp0_axr2 | spi1_cs0 | ecap2_in_pwm2_out | pr1_pru0_pru_r30_3 | pr1_pru0_pru_r31_3 | gpio3[17]
29 |  | B13 | 0x194 | MCASP0_FSX | mcasp0_fsx | ehrpwm0b |  | spi1_d0 | mmc1_sdcd | pr1_pru0_pru_r30_1 | pr1_pru0_pru_r31_1 | gpio3[15]
30 |  | D12 | 0x198 | MCASP0_AXR0 | mcasp0_axr0 | ehrpwm0_tripzone_input |  | spi1_d1 | mmc2_sdcd | pr1_pru0_pru_r30_2 | pr1_pru0_pru_r31_2 | gpio3[16]
31 |  | A13 | 0x190 | MCASP0_ACLKX | mcasp0_aclkx | ehrpwm0a |  | spi1_sclk | mmc0_sdcd | pr1_pru0_pru_r30_0 | pr1_pru0_pru_r31_0 | gpio3[14]
32 |  |  |  | VADC |  |  |  |  |  |  |  | 
33 |  | C8 |  | AIN4 |  |  |  |  |  |  |  | 
34 |  |  |  | AGND |  |  |  |  |  |  |  | 
35 |  | A8 |  | AIN6 |  |  |  |  |  |  |  | 
36 |  | B8 |  | AIN5 |  |  |  |  |  |  |  | 
37 |  | B7 |  | AIN2 |  |  |  |  |  |  |  | 
38 |  | A7 |  | AIN3 |  |  |  |  |  |  |  | 
39 |  | B6 |  | AIN0 |  |  |  |  |  |  |  | 
40 |  | C7 |  | AIN1 |  |  |  |  |  |  |  | 
41A |  | D14 | 0x1b4 | XDMA_EVENT_INTR1 | xdma_event_intr1 |  | tclkin | clkout2 | timer7 | pr1_pru0_pru_r31_16 | emu3 | gpio0[20]
41B |  | D13 | 0x1a8 | MCASP0_AXR1 | mcasp0_axr1 | eqep0_index |  | mcasp1_axr0 | emu3 | pr1_pru0_pru_r30_6 | pr1_pru0_pru_r31_6 | gpio3[20]
42A |  | C18 | 0x164 | ECAP0_IN_PWM0_OUT | ecap0_in_pwm0_out | uart3_txd | spi1_cs1 | pr1_ecap0_ecap_capin_apwm_0 | spi1_clk | mmc0_sdwp | xdma_event_intr2 | gpio0[7]
42B |  | B12 | 0x1a0 | MCASP0_ACLKR | mcasp0_aclkr | eqep0a_in | mcasp0_axr2 | mcasp1_aclkx | mmc0_sdwp | pr1_pru0_pru_r30_4 | pr1_pru0_pru_r31_4 | gpio3[18]
43 |  |  |  | GND |  |  |  |  |  |  |  | 
44 |  |  |  | GND |  |  |  |  |  |  |  | 
45 |  |  |  | GND |  |  |  |  |  |  |  | 
46 |  |  |  | GND |  |  |  |  |  |  |  | 

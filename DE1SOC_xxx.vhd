library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE1SOC_xxx is
 port(
	-- CLOCK ----------------
	CLOCK_50	: in	std_logic;
--	CLOCK2_50	: in	std_logic;
--	CLOCK3_50	: in	std_logic;
--	CLOCK4_50	: in	std_logic;
	-- KEY ----------------
--	KEY 		: in	std_logic_vector(0 downto 0);
	KEY 		: in	std_logic_vector(3 downto 0);
	-- SW ----------------
	SW 			: in	std_logic_vector(9 downto 0);
	-- LEDR ----------------
	LEDR 		: out	std_logic_vector(9 downto 0);
	-- GPIO ----------------
--	GPIO_0 		: inout	std_logic_vector(35 downto 0);
--	GPIO_1 		: inout	std_logic_vector(35 downto 0)
	-- ADC ----------------
--	ADC_CS_N		: out	std_logic;
--	ADC_DIN		: out	std_logic;
--	ADC_DOUT		: in	std_logic;
--	ADC_SCLK		: out	std_logic;
	-- CODEC Audio ----------------
	---AUD_ADCDAT	: in	std_logic;
	--AUD_ADCLRCK	: in	std_logic;
	AUD_BCLK		: in	std_logic;
	AUD_DACDAT	: out	std_logic;
	AUD_DACLRCK	: in	std_logic;
	AUD_XCK		: out	std_logic;
	-- SDRAM ----------------
--	DRAM_ADDR	: out	std_logic_vector(12 downto 0);
--	DRAM_BA		: out	std_logic_vector(1 downto 0);
--	DRAM_CAS_N	: out	std_logic;
--	DRAM_CKE		: out	std_logic;
--	DRAM_CLK		: out	std_logic;
--	DRAM_CS_N	: out	std_logic;
--	DRAM_DQ		: inout	std_logic_vector(15 downto 0);
--	DRAM_LDQM	: out	std_logic;
--	DRAM_RAS_N	: out	std_logic;
--	DRAM_UDQM	: out	std_logic;
--	DRAM_WE_N	: out	std_logic;
	-- I2C for Audio and Video-In ----------------
	FPGA_I2C_SCLK	: out	std_logic;
	FPGA_I2C_SDAT	: inout	std_logic;
	-- SEG7 ----------------
	HEX0	: out	std_logic_vector(6 downto 0);
	HEX1	: out	std_logic_vector(6 downto 0);
	HEX2	: out	std_logic_vector(6 downto 0);
	HEX3	: out	std_logic_vector(6 downto 0);
	HEX4	: out	std_logic_vector(6 downto 0);
	HEX5	: out	std_logic_vector(6 downto 0);
	-- IR ----------------
--	IRDA_RXD	: in	std_logic;
--	IRDA_TXD	: out	std_logic;
	-- PS2 ----------------
	PS2_CLK		: in	std_logic;
--	PS2_CLK2	: in	std_logic;
	PS2_DAT		: inout	std_logic
--	PS2_DAT2		: inout	std_logic;
	-- Video-In ----------------
--	TD_CLK27		: in	std_logic;
--	TD_DATA		: in	std_logic_vector(7 downto 0);
--	TD_HS			: in	std_logic;
--	TD_RESET_N	: out	std_logic;
--	TD_VS			: in	std_logic;
	-- VGA ----------------
--	VGA_B			: out	std_logic_vector(7 downto 0);
--	VGA_BLANK_N	: out	std_logic;
--	VGA_CLK		: out	std_logic;
--	VGA_G			: out	std_logic_vector(7 downto 0);
--	VGA_HS		: out	std_logic;
--	VGA_R			: out	std_logic_vector(7 downto 0);
--	VGA_SYNC_N	: out	std_logic;
--	VGA_VS		: out	std_logic;	: out	std_logic;
 );
end;

architecture rtl_0 of DE1SOC_xxx is 
	signal clk 		: std_logic;
    signal reset_l : std_logic;
    signal reset : std_logic; 
	signal Leds 	: unsigned(2 downto 0);
	
	constant PERIOD_CLK 	: time := 20 ns;    
	
	signal vol     : std_logic_vector(3 downto 0) := B"0000";

	

	signal cnt : unsigned(2 downto 0);

	type rom1 is array (0 to 7) of std_logic_vector(3 downto 0);
	constant rom_seg_0 : rom1 := (
		"0010", --DO   --261
		"0010", --RE   --293
		"0011", --MI   --329
		"0011", --FA   --349
		"0011", --SOL  --391
		"0100", --SI   --493
		"0100", --LA   --440
		"0101"  --DO_A --523
		);

	constant rom_seg_1 : rom1 := (
		"0110", --DO   --261
		"1001", --RE   --293
		"0100", --FA   --349
		"0010", --MI   --329
		"1001", --SOL  --391
		"1001", --SI   --493
		"0100", --LA   --440
		"0010"  --DO_A --523
		);
	constant rom_seg_2 : rom1 := (
			"0001", --DO   --261
			"0011", --RE   --293
			"1001", --MI   --329
			"1001", --FA   --349
			"0001", --SOL  --391
			"0011", --SI   --493
			"0000", --LA   --440
			"0011"  --DO_A --523
			);
	type rom2 is array (0 to 15) of std_logic_vector(3 downto 0);
	constant rom_vol_0 : rom2 := (
		"0000", --00
		"0000", --01
		"0000", --02
		"0000", --03
		"0000", --04
		"0000", --05
		"0000", --06
		"0000", --07
		"0000", --08
		"0000", --09
		"0001", --10
		"0001", --11
		"0001", --12
		"0001", --13
		"0001", --14
		"0001"  --15
		);
	constant rom_vol_1 : rom2 := (
		"0000", --00
		"0001", --01
		"0010", --02
		"0011", --03
		"0100", --04
		"0101", --05
		"0110", --06
		"0111", --07
		"1000", --08
		"1001", --09
		"0000", --10
		"0001", --11
		"0010", --12
		"0011", --13
		"0100", --14
		"0101"  --15
		);




	signal 	NumTicsXSecond 		: unsigned(31 downto 0);	-- Contador de TICs de clk
	signal  TicSec				: std_logic;				-- Ha pasado 1 segundo (se activa solo 1 ciclo de clk)
	
	component control_del_codec is
		port (
		  clk       : in std_logic;
		  reset_l   : in std_logic;
		  pulsado   : in std_logic;
		  nota      : in std_logic_vector(3 downto 0);
		  vol_plus  : in std_logic;
    	  vol_minus : in std_logic;
		  bclk      : in std_logic;
		  daclrc    : in std_logic;
		  dacdat    : out std_logic;
		  i2c_sclk  : out std_logic;
		  freq2     : out std_logic_vector(11 downto 0) ;
		  i2c_sdat  : inout std_logic;
		  xck       : out std_logic
		) ;
	  end component ; 
	  
	component control_del_teclado is
		port (
			clk     : in std_logic;
			reset_l : in std_logic;
			ps2_clk : in std_logic;
			ps2_dat : in std_logic;
			pulsado : out std_logic;
			cod_k   : out std_logic_vector(7 downto 0);
			tecla   : out std_logic_vector(3 downto 0)
		) ;
	end component ; 
	

	signal i2c_sdat	:  STD_LOGIC;
	signal i2c_sclk	:  STD_LOGIC;

	component hex_7seg is
		port
		(
			hex	: in	std_logic_vector(3 downto 0);
			dig	: out	std_logic_vector(6 downto 0)
		);
	end component;
	--Señales limpias
	signal my_keys: std_logic_vector(3 downto 0);
	signal my_keys_1: std_logic_vector(3 downto 0);
	signal my_keys_2: std_logic_vector(3 downto 0);
	signal my_keys_limpio: std_logic_vector(3 downto 0);
	
	signal sw_1: std_logic_vector(9 downto 0);
	signal sw_2: std_logic_vector(9 downto 0);
	signal sw_l: std_logic_vector(9 downto 0);
	signal pulsado: std_logic;
	signal nota : std_logic_vector(3 downto 0);
	signal freq: std_logic_vector(11 downto 0);
	
	signal clk_div : std_logic;
	component div_freq is
		port (
		  clk: in std_logic;
		  reset_l : in std_logic;
		  clk_div : out std_logic
		) ;
	end component ; 

	signal cod_k   : std_logic_vector(7 downto 0);
	signal vol_minus : std_logic;
	signal vol_plus : std_logic;
begin 

	df : div_freq
	port  map(
	  clk => clk,
	  reset_l => reset_l,
	  clk_div => clk_div
	) ;

	--  Input PINs Asignements
    clk <= CLOCK_50; 
	reset_l <= KEY(0);
	LEDR(0) <= pulsado;

	-- Output PINs Asignements
	--LEDR <= freq(9 downto 0);	
	my_keys_limpio <= KEY;
	sw_l <= SW;
	
	control_del_teclado_comp	: control_del_teclado
	port map (
		clk     => clk,
		reset_l => reset_l,
		ps2_clk => PS2_CLK,
		ps2_dat => PS2_DAT,
		pulsado => pulsado,
		cod_k => cod_k,
		tecla   => nota
	) ;
	
	control_del_codec_comp : control_del_codec
	port map (
		  clk       => clk,
		  reset_l   => reset_l,
		  pulsado   => pulsado,
		  nota      => nota,
		  vol_minus => vol_minus,
		  vol_plus  => vol_plus
		  freq2	    => freq,
		  bclk      => AUD_BCLK,
		  daclrc    => AUD_DACLRCK,
		  dacdat    => AUD_DACDAT,
		  i2c_sclk  => FPGA_I2C_SCLK,
		  i2c_sdat  => FPGA_I2C_SDAT,
		  xck       => AUD_XCK
	) ;

	limpiar_senales : process (clk, reset_l)
	begin
		if reset_l  = '0' then
			my_keys <= "111" & KEY(0); -- El 0 es el reset, que no hay que modificar
			my_keys_1 <= "111" & KEY(0);
			my_keys_2 <= "111" & KEY(0);
			sw_1 <= B"00_0000_0000";
			sw_2 <= B"00_0000_0000";
		elsif clk'event and clk = '1' then
			my_keys <= KEY;
			my_keys_1 <= my_keys;
			my_keys_2 <= my_keys_1;
			sw_1 <= SW;
			sw_2 <= sw_1;
		end if ;
	end process; -- limpiar_senales
	
	--------------------------7Segmentos
	--  hex5_7: hex_7seg
    --  port map(	
	--     hex => rom_seg_0(to_integer(SW(8) & SW(7) & SW(6))),
	--     dig => HEX5
    --      );
	

	--  hex4_7: hex_7seg 
	--  port map(	
	--  	hex => rom_seg_1(to_integer(SW(8) & SW(7) & SW(6))),
	--      dig => HEX4
	--  	);

	-- hex3_7: hex_7seg 
	-- port map(	
	-- 	hex => rom_seg_2(to_integer(SW(8) & SW(7) & SW(6))),
	--     dig => HEX3
	-- 	);

	hex1_7: hex_7seg 
	port map(	
		hex => rom_vol_0(to_integer(SW(3) & SW(2) & SW(1) & SW(0))),
		dig => HEX1
		);
	hex0_7: hex_7seg 
	port map(	
		hex => rom_vol_1(to_integer(SW(3) & SW(2) & SW(1) & SW(0))),
		dig => HEX0
		);

	hex5_7: hex_7seg
      port map(	
	     hex => freq(11 downto 8),
	     dig => HEX5
		  );
	hex4_7: hex_7seg
	port map(	
		hex => freq(7 downto 4),
		dig => HEX4
		);
	hex3_7: hex_7seg
      port map(	
	     hex => freq(3 downto 0),
	     dig => HEX3
		  );
	hex2_2: hex_7seg
	port map(	
		hex => nota,
		dig => HEX2
		);
	
END rtl_0;
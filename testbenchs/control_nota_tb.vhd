library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity control_nota_tb is
end control_nota_tb ; 

architecture arch1 of control_nota_tb is

  signal clk : std_logic := '1'; 
  constant PERIOD_CLK : time := 20 ns;
  constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
  constant PERIOD_BCLK : time := 320 ns;
  constant HALF_PERIOD_BCLK : time := PERIOD_BCLK/2;
  constant PERIOD_DACLRC : time := 122880 ns;
  constant HALF_PERIOD_DACLRC : time := PERIOD_DACLRC/2;

  signal reset_l : std_logic;
  signal nota : std_logic_vector (2 downto 0);
  signal pulsado : std_logic;
  signal rom_dat : std_logic_vector(11 downto 0);
  signal rom_dir : std_logic_vector(2 downto 0);
  signal freq : std_logic_vector(11 downto 0);
  signal enable: std_logic;


  component control_nota is
    port (
      clk     : in std_logic;
      reset_l : in std_logic;
      pulsado : in std_logic;
      nota    : in std_logic_vector(2 downto 0);
      freq    : out std_logic_vector(11 downto 0);
      enable  : out std_logic
      ) ;
  end component ; 
begin

  clk <= not clk after HALF_PERIOD_CLK;

  estim_reset : process
  begin
    reset_l <= '0';
    wait for 31 ns;
    reset_l <= '1';
    wait;
  end process; -- estim_reset

  DUT: control_nota
    port map(
      clk     => clk,
      reset_l => reset_l,
      pulsado => pulsado,
      nota =>  nota,
      freq => freq,
      enable => enable
    );
  
  

  estimulos : process
  begin
    nota <= "000";
    pulsado <= '0';
    wait for 45 ns;
    nota <= "110";
    wait for HALF_PERIOD_CLK;
    pulsado <= '1';
    wait for PERIOD_DACLRC*20;
    pulsado <= '0';
    wait for HALF_PERIOD_CLK;
    nota <= "011";
    wait for HALF_PERIOD_CLK;
    pulsado <= '1';
    wait;
  end process; -- estimulos
  
end architecture ;

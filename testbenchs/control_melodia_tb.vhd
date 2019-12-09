library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_melodia_tb is
end control_melodia_tb ; 

architecture arch of control_melodia_tb is
    component  control_melodia is
        port (
          clk     : in std_logic;
          reset_l : in std_logic;
          pulsado : in std_logic;
          cod_mel : in std_logic_vector(1 downto 0) ;
          nota_mel : out std_logic_vector(3 downto 0) ;
          enable_mel: out std_logic
        ) ;
      end  component; 

      signal reset_l : std_logic := '0'; 
      signal clk : std_logic := '1'; 
      signal ps2_clk : std_logic := '1'; 
      constant PERIOD_CLK : time := 20 ns;
      constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
      constant PERIOD_CLK_PS2 : time := 70 us;
      constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;
      signal pulsado : std_logic;
      signal cod_mel : std_logic_vector(1 downto 0) ;
      signal nota_mel : std_logic_vector(3 downto 0) ;
      signal enable_mel: std_logic;

begin
   
    DUT :  control_melodia
        port map(
          clk     => clk,
          reset_l => reset_l,
          pulsado => pulsado,
          cod_mel => cod_mel,
          nota_mel => nota_mel,
          enable_mel=> enable_mel
        ) ;
    clk <= not clk after HALF_PERIOD_CLK;

    estim_reset : process
    begin
        reset_l <= '0';
        wait for 31 ns;
        reset_l <= '1';
        wait;
    end process; -- estim_reset

    estimulos : process
    begin
        pulsado <= '1';
        cod_mel <= "00";
        wait;
    end process ; -- estimulos

end architecture ;
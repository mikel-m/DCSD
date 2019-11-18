library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_control_pulsado_tb is
end tec_control_pulsado_tb ; 

architecture arch1 of tec_control_pulsado_tb is
    signal clk : std_logic := '0'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;

    signal reset_l : std_logic := '0';
    
    component tec_control_pulsado is
        port (
          clk     : in std_logic;
          reset_l : in std_logic;
          make    : in std_logic;
          break   : in std_logic;
          codigo  : in std_logic_vector(7 downto 0);
          tecla   : out std_logic_vector(3 downto 0);
          pulsado : out std_logic
        ) ;
    end component ; 
    
    signal pulsado : std_logic;
    signal make   : std_logic; 
    signal break  : std_logic;
    signal codigo : std_logic_vector(7 downto 0);
    signal tecla  : std_logic_vector(3 downto 0);

begin
    clk <= not clk after HALF_PERIOD_CLK;

    DUT : tec_control_pulsado
    port map (
        clk     => clk ,
        reset_l => reset_l ,
        make    => make ,
        break   => break ,
        codigo  => codigo ,
        tecla   => tecla ,
        pulsado => pulsado
      ) ;

    estim_reset : process
    begin
        reset_l <= '0';
        wait for 21 ns;
        reset_l <= '1';
        wait;
    end process ; -- estim_reset

    estimulos : process
    begin
        wait for 2 ns;
        wait for PERIOD_CLK_PS2;
        codigo <= X"0D";
        make <= '1';
        wait for HALF_PERIOD_CLK;
        make <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"0F";
        break <= '1';
        wait for HALF_PERIOD_CLK;
        break <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"0F";
        make <= '1';
        wait for HALF_PERIOD_CLK;
        make <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"0D";
        break <= '1';
        wait for HALF_PERIOD_CLK;
        break <= '0';
        wait;
    end process ; -- estimulos
end architecture ;
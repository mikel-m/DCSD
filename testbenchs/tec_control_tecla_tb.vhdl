library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_control_tecla_tb is
end tec_control_tecla_tb ; 

architecture arch1 of tec_control_tecla_tb is
    signal clk : std_logic := '0'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;

    signal reset_l : std_logic := '0';
    
    component tec_control_tecla is
        port (
            clk        : in std_logic;
            reset_l    : in std_logic;
            fin        : in std_logic;
            codigo_in  : in std_logic_vector(7 downto 0);
            codigo_out : out std_logic_vector(7 downto 0);
            make       : out std_logic;
            break      : out std_logic
        ) ;
    end component ; 
    
    signal fin : std_logic;
    signal make   : std_logic; 
    signal break  : std_logic;
    signal codigo : std_logic_vector(7 downto 0);
    signal codigo_out  : std_logic_vector(7 downto 0);
    

begin
    clk <= not clk after HALF_PERIOD_CLK;

    DUT : tec_control_tecla
    port map (
        clk     => clk ,
        reset_l => reset_l ,
        fin    => fin ,
        codigo_in   => codigo ,
        codigo_out  => codigo_out ,
        make   => make ,
        break => break
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
        codigo <= X"23";
        fin <= '1';
        wait for HALF_PERIOD_CLK;
        fin <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"F0";
        fin <= '1';
        wait for HALF_PERIOD_CLK;
        fin <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"23";
        fin <= '1';
        wait for HALF_PERIOD_CLK;
        fin <= '0';
        wait for PERIOD_CLK_PS2 - HALF_PERIOD_CLK;
        codigo <= X"23";
        fin <= '1';
        wait for HALF_PERIOD_CLK;
        fin <= '0';
        wait;
    end process ; -- estimulos
end architecture ;
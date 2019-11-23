library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_limpiar_senales_tb is
end tec_limpiar_senales_tb ; 

architecture arch1 of tec_limpiar_senales_tb is
    component tec_limpiar_senales is
        port (
          clk            : in std_logic;
          reset_l        : in std_logic;
          ps2_clk        : in std_logic;
          ps2_dat        : in std_logic;
          ps2_clk_limpio : out std_logic;
          ps2_dat_limpio : out std_logic
        ) ;
      end component ; 
      
    signal clk              : std_logic := '0';
    signal reset_l          : std_logic;
    signal ps2_clk          : std_logic;
    signal ps2_dat          : std_logic;
    signal ps2_clk_limpio   : std_logic;
    signal ps2_dat_limpio   : std_logic;

    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;


begin
    clk <= not clk after HALF_PERIOD_CLK;
    DUT: tec_limpiar_senales
    port map (
        clk            => clk,
        reset_l        => reset_l,
        ps2_clk        => ps2_clk,
        ps2_dat        => ps2_dat,
        ps2_clk_limpio => ps2_clk_limpio,
        ps2_dat_limpio => ps2_dat_limpio
    ) ;

    es_res : process
    begin
        reset_l <= '0';
        wait for 23 ns;
        reset_l <= '1';
        wait;
    end process ; -- es_res

    estim : process
    begin
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '1';
        ps2_clk <= '1';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        ps2_dat <= '0';
        ps2_clk <= '0';
        wait for PERIOD_CLK;
        
        wait;
    end process ; -- estim
end architecture ;
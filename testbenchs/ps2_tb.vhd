library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity ps2_tb is
end ps2_tb ; 

architecture arch1 of ps2_tb is
    signal clk : std_logic := '1'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    
    signal clk_ps2 : std_logic := '1';
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;
    signal reset_l :std_logic;
    signal pulsado : std_logic;
    signal data    : std_logic := '1';
    signal enable  : std_logic;
    signal clk_ps2 : std_logic;
    signal clk     : std_logic;
    component ps2 is
        port (
          clk_ps2 : in std_logic;
          reset_l : in std_logic;
          clk     : in std_logic;
          pulsado : out std_logic;
          data    : in std_logic;
          enable  : out std_logic
        ) ;
      end component ; 
begin
    clk <= not clk after HALF_PERIOD_CLK;
    clk_ps2 <= not clk_ps2 after HALF_PERIOD_CLK;


    DUT: ps2
        port map(
          clk_ps2   =>  clk_ps2, 
          reset_l   =>  reset_l, 
          clk       =>  clk, 
          pulsado   =>  pulsado, 
          data      =>  data, 
          enable    =>  enable
        ) ;


    estim_reset : process
    begin
        reset_l <= '0';
        wait for 31 ns;
        reset_l <= '1';
        wait;
    end process; -- estim_reset

    estimulos : process
    begin
        data <= '1';
        wait for 40 ns;
        wait for PERIOD_CLK_PS2;
        
        wait;
    end process ; -- estimulos
end architecture ;
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity enviar_muestra_tb is
end enviar_muestra_tb ; 

architecture arch1 of enviar_muestra_tb is
    signal reset_l : std_logic := '0'; 
    signal clk : std_logic := '1'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
  
    signal bclk: std_logic := '0';
    signal daclrc: std_logic := '1';
    constant PERIOD_BCLK : time := 320 ns;
    constant HALF_PERIOD_BCLK : time := PERIOD_BCLK/2;
    constant PERIOD_DACLRC : time := 122880 ns;
    constant HALF_PERIOD_DACLRC : time := PERIOD_DACLRC/2;

    
    component enviar_muestra
    port (
        clk: in std_logic;
        reset_l: in std_logic;
        bclk: in std_logic;
        daclrc: in std_logic;
        muestra: in std_logic_vector(15 downto 0);
        siguiente_muestra: out std_logic;
        dacdat: out std_logic
        );
    end component;

    signal muestra: std_logic_vector(15 DOWNTO 0) := "0101111101000001";
    signal dacdat: std_logic;
    signal siguiente_muestra: std_logic;
        
begin
            
    clk <= not clk after HALF_PERIOD_CLK;

    bclk_clock : process
    begin
        wait for 1 ns;
        bclk <= '0';
        wait for HALF_PERIOD_BCLK - (1 ns);
        bclk <= '1';
        wait for HALF_PERIOD_BCLK;
    end process ; -- bclk_clock
    
    daclrc_clock : process
    begin
        wait for 1 ns;
        daclrc <= '0';
        wait for HALF_PERIOD_DACLRC - (1 ns);
        daclrc <= '1';
        wait for HALF_PERIOD_DACLRC;
    end process ; -- daclrc_clock
    -- instancia del modulo a testear
    DUT: enviar_muestra  
    port map ( 
        clk => clk,
        reset_l => reset_l,
        bclk => bclk,
        daclrc => daclrc,
        muestra => muestra,
        dacdat => dacdat,
        siguiente_muestra => siguiente_muestra
    ); 

    estim_reset : process
    begin
        wait for 53 ns;
        reset_l <= '1';
        wait until siguiente_muestra = '1';
        muestra <= B"0111_0000_1111_1110";
        wait until siguiente_muestra = '1';
        muestra <= B"1000_0110_1001_1010";
        wait;
    end process ; -- estim_reset


end architecture ;

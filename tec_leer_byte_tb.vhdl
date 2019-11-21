library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_leer_byte_tb is
end tec_leer_byte_tb ;

architecture arch1 of tec_leer_byte_tb is
    signal reset_l : std_logic := '0'; 
    signal clk : std_logic := '1'; 
    signal ps2_clk : std_logic := '1'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;

    component tec_leer_byte
    port (
        clk: in std_logic;
        reset_l: in std_logic;
        ps2_clk: in std_logic;
        ps2_dat: in std_logic;
        fin: out std_logic;
        codigo: out std_logic_vector(7 downto 0)
        );
    end component;


    signal ps2_dat : std_logic;
    signal fin : std_logic;
    signal codigo: std_logic_vector(7 downto 0);

    begin

        clk <= not clk after HALF_PERIOD_CLK;

        ps2_clock : process
        begin
            wait for 1 ns;
            ps2_clk <= '0';
            wait for HALF_PERIOD_CLK_PS2 - (1 ns);
            ps2_clk <= '1';
            wait for HALF_PERIOD_CLK_PS2;
        end process ;


        estim_reset : process
        begin
          reset_l <= '0';
          wait for 31 ns;
          reset_l <= '1';
          wait;
        end process; -- estim_reset
      
        DUT: tec_leer_byte
        port map(
            clk     => clk,
            reset_l => reset_l,
            ps2_clk => ps2_clk,
            ps2_dat =>  ps2_dat,
            fin => fin,
            codigo => codigo
          );
-- Byte => 1000_0001
          estimulos : process
          begin
            ps2_dat <= '1';
            wait for PERIOD_CLK_PS2*3;
            ps2_dat <= '0';--Start
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '1'; --0
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --1
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --2
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --3
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --4
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --5
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '0'; --6
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '1';--7
            wait for PERIOD_CLK_PS2;
            ps2_dat <= '1'; --8
            wait for PERIOD_CLK_PS2;
            --Stop
            ps2_dat <= '1';
            wait;
          end process; -- estimulos
          
        end architecture ;
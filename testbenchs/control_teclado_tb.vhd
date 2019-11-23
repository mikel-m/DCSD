library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_teclado_tb is
end control_teclado_tb ; 

architecture arch1 of control_teclado_tb is


    component control_del_teclado is
        port (
            clk     : in std_logic;
            reset_l : in std_logic;
            ps2_clk : in std_logic;
            ps2_dat : in std_logic;
            pulsado : out std_logic;
            tecla   : out std_logic_vector(2 downto 0)
        ) ;
    end component ; 

    signal reset_l : std_logic := '0'; 
    signal clk : std_logic := '1'; 
    signal ps2_clk : std_logic := '1'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;

    signal ps2_dat : std_logic;
    signal pulsado : std_logic;
    signal tecla : std_logic_vector(2 downto 0);
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

    DUT : control_del_teclado
        port map (
            clk     => clk,
            reset_l => reset_l,
            ps2_clk => ps2_clk,
            ps2_dat => ps2_dat,
            pulsado => pulsado,
            tecla   => tecla
        ) ;



    estimulos : process
    begin
      ps2_dat <= '1';
      wait for PERIOD_CLK_PS2*3;
      ps2_dat <= '0';--Start 0x23
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --1
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --2
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --3
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --4
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --5
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --6
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0';--7
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --PAR
      wait for PERIOD_CLK_PS2; 
      ps2_dat <= '1'; --Stop 0x23
      wait for PERIOD_CLK_PS2;


      ps2_dat <= '0';--Start 0xF0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --1
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --2
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --3
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --4
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --5
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --6
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1';--7
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --PAR
      wait for PERIOD_CLK_PS2; 
      ps2_dat <= '1'; --Stop 0xF0
      wait for PERIOD_CLK_PS2;


      ps2_dat <= '0';--Start 0x23
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --1
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --2
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --3
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --4
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --5
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --6
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0';--7
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --PAR
      wait for PERIOD_CLK_PS2; 
      ps2_dat <= '1'; --Stop 0x23
      wait;
    end process; -- estimulos

end architecture ;
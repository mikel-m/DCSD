library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_teclado_tb is
end control_teclado_tb ; 

architecture arch1 of control_teclado_tb is


    component control_del_teclado is
        port (
            clk       : in std_logic;
	        reset_l   : in std_logic;
	        ps2_clk   : in std_logic;
	        ps2_dat   : in std_logic;
            pulsado : out std_logic;
            nota      : out std_logic_vector(3 downto 0);
            
	        enable    : out std_logic;
	        cod_k     : out std_logic_vector(7 downto 0);
	        vol_plus  : out std_logic;
	        vol_minus : out std_logic;
            nota_mel  : in std_logic_vector(3 downto 0);
            tecla_mel : out std_logic_vector(1 downto 0) ;
            enable_mel: in std_logic
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
    signal nota : std_logic_vector(3 downto 0);

    signal enable    : std_logic;
    signal cod_k     : std_logic_vector(7 downto 0);
    signal vol_plus  : std_logic;
    signal vol_minus : std_logic;
    signal nota_mel  : std_logic_vector(3 downto 0);
    signal tecla_mel : std_logic_vector(1 downto 0) ;
    signal enable_mel: std_logic;



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
            nota   => nota,
            enable => enable, 
            cod_k => cod_k,
            vol_plus => vol_plus,
            vol_minus => vol_minus, 
            nota_mel => X"0", 
            tecla_mel => tecla_mel, 
            enable_mel => '0'
        ) ;



    estimulos : process
    begin
      ps2_dat <= '1';
      wait for PERIOD_CLK_PS2*3;
      ps2_dat <= '0';--Start 0x16
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --1
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --2
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --3
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --4
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --5
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --6
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0';--7
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --PAR
      wait for PERIOD_CLK_PS2; 
      ps2_dat <= '1'; --Stop 0x16
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


      ps2_dat <= '0';--Start 0x16
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --0
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --1
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --2
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --3
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '1'; --4
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --5
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --6
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0';--7
      wait for PERIOD_CLK_PS2;
      ps2_dat <= '0'; --PAR
      wait for PERIOD_CLK_PS2; 
      ps2_dat <= '1'; --Stop 0x16
      wait;
    end process; -- estimulos

end architecture ;
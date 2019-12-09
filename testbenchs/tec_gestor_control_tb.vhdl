library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_gestor_control_tb is
end tec_gestor_control_tb ;

architecture arch1 of tec_gestor_control_tb is
    signal reset_l : std_logic := '0'; 
    signal clk : std_logic := '1'; 
    signal ps2_clk : std_logic := '0'; 
    constant PERIOD_CLK : time := 20 ns;
    constant HALF_PERIOD_CLK : time := PERIOD_CLK/2;
    constant PERIOD_CLK_PS2 : time := 70 us;
    constant HALF_PERIOD_CLK_PS2 : time := PERIOD_CLK_PS2/2;

    component tec_gestor_tecla
    port (
      clk     : in std_logic;
      reset_l : in std_logic;
      codigo2 : in std_logic_vector(7 downto 0);
      pulsado : in std_logic;
      nota : out std_logic_vector(3 downto 0) ;
      vol_plus : out std_logic;
      vol_minus : out std_logic;
      enable : out std_logic;
      nota_mel : in std_logic_vector(3 downto 0) ;
      enable_mel: in std_logic
    );
    end component;

    signal codigo2 : std_logic_vector(7 downto 0);
    signal pulsado : std_logic;
    signal nota : std_logic_vector(3 downto 0) ;
    signal vol_plus : std_logic;
    signal vol_minus : std_logic;
    signal enable : std_logic;
    signal nota_mel : std_logic_vector(3 downto 0) ;
    signal enable_mel: std_logic;

    
    begin

        clk <= not clk after HALF_PERIOD_CLK;

        ps2_clock : process
        begin
            wait for 1 ns;
            ps2_clk <= '1';
            wait for HALF_PERIOD_CLK_PS2 - (1 ns);
            ps2_clk <= '0';
            wait for HALF_PERIOD_CLK_PS2;
        end process ;


        estim_reset : process
        begin
          reset_l <= '0';
          wait for 31 ns;
          reset_l <= '1';
          wait;
        end process; -- estim_reset
      
        DUT: tec_gestor_tecla
        port map(
          clk        => clk,
          reset_l    => reset_l,
          codigo2    => codigo2,
          pulsado    => pulsado,
          nota       => nota,
          vol_plus   => vol_plus,
          vol_minus  => vol_minus,
          enable     => enable,
          nota_mel   => nota_mel,
          enable_mel => enable_mel
        );
-- Byte => 1000_0001
          estimulos : process
          begin
            codigo2 <= X"16";
            pulsado <= '0';
            nota_mel <= X"3";
            enable_mel <= '1';
            wait for PERIOD_CLK_PS2*3;
            pulsado <= '1';
            wait for PERIOD_CLK_PS2;
            nota_mel <= X"4";
            pulsado <= '0';
           wait;
          end process; -- estimulos
          
        end architecture ;
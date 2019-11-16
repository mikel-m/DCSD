library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_del_teclado is
    port (
        clk     : in std_logic;
        reset_l : in std_logic;
        ps2_clk : in std_logic;
        ps2_dat : in std_logic;
        pulsado : out std_logic;
        tecla   : out std_logic_vector(2 downto 0)
    ) ;
end control_del_teclado ; 

architecture arch1 of control_del_teclado is
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

    component tec_leer_byte is
        port (
          clk     : in std_logic;
          reset_l : in std_logic;
          ps2_clk : in std_logic;
          ps2_dat : in std_logic;
          fin     : out std_logic;
          codigo  : out std_logic_vector(7 downto 0)
        ) ;
    end component ; 

    signal ps2_clk_limpio: std_logic;
    signal ps2_dat_limpio: std_logic;

    signal fin: std_logic;
    signal codigo: std_logic_vector(7 downto 0) ;
begin

    limp_sen_comp : tec_limpiar_senales
    port map (
        clk            => clk,
        reset_l        => reset_l,
        ps2_clk        => ps2_clk,
        ps2_dat        => ps2_dat,
        ps2_clk_limpio => ps2_clk_limpio,
        ps2_dat_limpio => ps2_dat_limpio
    ) ;

    leer_byte_comp : tec_leer_byte
    port map (
        clk     => clk,
        reset_l => reset_l,
        ps2_clk => ps2_clk_limpio,
        ps2_dat => ps2_dat_limpio,
        fin     => fin,
        codigo  => codigo
    ) ;
end architecture ;
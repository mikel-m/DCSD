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

    component tec_control_pulsado is
        port (
          clk     : in std_logic;
          reset_l : in std_logic;
          make    : in std_logic;
          break   : in std_logic;
          codigo  : in std_logic_vector(7 downto 0);
          tecla   : out std_logic_vector(2 downto 0);
          pulsado : out std_logic
        ) ;
      end component ; 

    signal ps2_clk_limpio: std_logic;
    signal ps2_dat_limpio: std_logic;

    signal fin: std_logic;
    signal codigo: std_logic_vector(7 downto 0) ;
    signal codigo_out: std_logic_vector(7 downto 0);
    signal make  : std_logic;
    signal break : std_logic;
    
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

    control_tecla_comp : tec_control_tecla
        port map (
            clk        => clk,
            reset_l    => reset_l,
            fin        => fin,
            codigo_in  => codigo,
            codigo_out => codigo_out,
            make       => make,
            break      => break
        ) ;

    control_pulsado_comp : tec_control_pulsado
        port map (
            clk     => clk,
            reset_l => reset_l,
            make    => make,
            break   => break,
            codigo  => codigo_out,
            tecla   => tecla,
            pulsado => pulsado
        ) ;
end architecture ;
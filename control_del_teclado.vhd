library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_del_teclado is
    port (
        clk       : in std_logic;
	    reset_l   : in std_logic;
	    ps2_clk   : in std_logic;
	    ps2_dat   : in std_logic;
	    enable    : out std_logic;
	    cod_k     : out std_logic_vector(7 downto 0);
	    nota      : out std_logic_vector(3 downto 0);
	    vol_plus  : out std_logic;
	    vol_minus : out std_logic;
        nota_mel  : in std_logic_vector(3 downto 0);
        tecla_mel : out std_logic_vector(1 downto 0) ;
        enable_mel: in std_logic;
        pulsado : out std_logic
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
          codigo2 : out std_logic_vector(7 downto 0);
          pulsado : out std_logic
        ) ;
      end component ; 

      component  tec_gestor_tecla is
        port (
          clk       : in std_logic;
          reset_l   : in std_logic;
          codigo2   : in std_logic_vector(7 downto 0);
          pulsado   : in std_logic;
          vol_plus  : out std_logic;
          vol_minus : out std_logic;
          enable    : out std_logic;
          nota_mel  : in std_logic_vector(3 downto 0) ;
          nota      : out std_logic_vector(3 downto 0);
          enable_mel: in std_logic;
          tecla_mel : out std_logic_vector(1 downto 0)
        ) ;
      end component; 
      

    signal ps2_clk_limpio: std_logic;
    signal ps2_dat_limpio: std_logic;

    signal fin: std_logic;
    signal codigo: std_logic_vector(7 downto 0) ;
    signal codigo_out: std_logic_vector(7 downto 0);
    signal make  : std_logic;
    signal break : std_logic;
    signal pulsado_int : std_logic;
    signal tecla : std_logic_vector(3 downto 0);
    signal cod_k_int : std_logic_vector(7 downto 0);
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
            codigo2 => cod_k_int,
            reset_l => reset_l,
            make    => make,
            break   => break,
            codigo  => codigo_out,
            pulsado => pulsado_int
        ) ;

    gestor_tecla_comp :  tec_gestor_tecla
        port map (
            clk       => clk,
            reset_l   => reset_l,
            codigo2   => cod_k_int,
            pulsado   => pulsado_int,
            vol_plus  => vol_plus,
            vol_minus => vol_minus,
            enable    => enable,
            nota_mel  => nota_mel,
            nota      => tecla,
            enable_mel=> enable_mel,
            tecla_mel => tecla_mel            
        ) ;
        nota <= tecla;
        cod_k <= cod_k_int;
        pulsado <= pulsado_int;
end architecture ;
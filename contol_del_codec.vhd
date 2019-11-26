library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity control_del_codec is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    pulsado : in std_logic;
    nota    : in std_logic_vector(3 downto 0);
    vol     : in std_logic_vector(3 downto 0);
    bclk    : in std_logic;
    daclrc  : in std_logic;
    dacdat  : out std_logic;
    i2c_sclk: inout std_logic;
    i2c_sdat: inout std_logic;
    freq2   : out std_logic_vector(11 downto 0) ;
    xck     : out std_logic
  ) ;
end control_del_codec ; 

architecture arch1 of control_del_codec is
    component enviar_muestra
    port (
        clk     : in std_logic;
        reset_l : in std_logic;
        bclk    : in std_logic;
        daclrc  : in std_logic;
        muestra : in std_logic_vector(15 downto 0);
        siguiente_muestra: out std_logic;
        dacdat  : out std_logic
    ) ;
    end component;

    component control_nota is
        port (
            clk     : in std_logic;
            reset_l : in std_logic;
            pulsado : in std_logic;
            nota    : in std_logic_vector(3 downto 0);
            freq    : out std_logic_vector(11 downto 0);
            enable  : out std_logic
        ) ;
    end component ; 

    component au_setup 
        port(
            reset		:  in std_logic;
            clk_50 		:  in std_logic;
            mic_lin		:  in std_logic;    -- si '1' MIC, si '0' LINEIN
            i2c_sdat	:  inout std_logic;
            i2c_sclk	:  out std_logic;
            aud_xck		:  out std_logic
        );
    end component;

    component sin_dds 
    port(	
        clk_50 		: in  std_logic;
        reset 		: in  std_logic;
        freq 		: in  std_logic_vector(11 downto 0); -- frecuencia en hz (entero, sin decimales)
        voldec 		: in std_logic_vector(3 downto 0); -- nivel de reducción de volumen (0 a 15)
        nextsample 	: in std_logic;
        enable 		: in std_logic;
        sample 		: out  std_logic_vector(15 downto 0)
    );
    end component;

    signal muestra: std_logic_vector(15 downto 0) ;
    signal siguiente_muestra: std_logic;
    signal mic_lin: std_logic;

    signal enable: std_logic;
    signal freq: std_logic_vector(11 downto 0) ;

    signal reset: std_logic;
begin
    mic_lin <= '0';
    reset <= not reset_l;
    freq2 <= freq;
    env_mues_comp : enviar_muestra
    port map ( 
        clk => clk,
        reset_l => reset_l,
        bclk => bclk,
        daclrc => daclrc,
        muestra => muestra,
        dacdat => dacdat,
        siguiente_muestra => siguiente_muestra
	); 
    
    au_set_comp : au_setup
	 port map (
		reset	 => reset,
		clk_50   => clk,
		mic_lin	 => mic_lin,    -- si '1' MIC, si '0' LINEIN
		i2c_sdat => i2c_sdat,
		i2c_sclk => i2c_sclk,
		aud_xck	 => xck
    );

    cont_nota_comp : control_nota
    port map(
      clk     => clk,
      reset_l => reset_l,
      pulsado => pulsado,
      nota    => nota,
      freq    => freq,
      enable  => enable
    );

    sin_dds_comp : sin_dds
    port map(	
        clk_50      => clk,
        reset       => reset,
        freq        => freq, -- frecuencia en hz (entero, sin decimales)
        voldec      => vol, -- nivel de reducción de volumen (0 a 15)
        nextsample  => siguiente_muestra,
        enable      => enable,
        sample      => muestra
    );
	

end architecture ;
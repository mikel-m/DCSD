library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_control_pulsado is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    make    : in std_logic;
    break   : in std_logic;
    codigo  : in std_logic_vector(7 downto 0);
    codigo2 : out std_logic_vector(7 downto 0);
    pulsado : out std_logic
  ) ;
end tec_control_pulsado ; 

architecture arch1 of tec_control_pulsado is
    TYPE t_estado is (E_INICIO, E_ESPERA_BREAK, E_COMPROBAR_TECLA);
    signal EP, ES, ESTADO: t_estado;

    signal cod  : std_logic_vector(7 downto 0);
    signal cod2 : std_logic_vector(7 downto 0);
    signal ld_cod  : std_logic;
    signal ld_cod2 : std_logic;
    signal cod_eq_cod2 : std_logic;
    signal ld_pulsado  : std_logic;
    signal pulsado_out : std_logic;
    signal pulsado_in  : std_logic;

begin

-- UC
    --Salida
    pulsado <= pulsado_out;
    codigo2 <= cod;
    --Salida UP
    ld_cod     <= '1' when EP = E_INICIO and make = '1' else '0';
    pulsado_in <= '1' when EP = E_INICIO and make = '1' else '0';
    ld_pulsado <= '1' when (EP = E_INICIO and make = '1') or (EP = E_COMPROBAR_TECLA and cod_eq_cod2 = '1') else '0';
    ld_cod2    <= '1' when EP = E_ESPERA_BREAK and break = '1' else '0';

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
            EP <= E_INICIO;
        elsif rising_edge(clk) then
            EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados : process(EP, make, break, cod_eq_cod2)
    begin
        case EP is
        when E_INICIO           =>  if make = '1' then
                                        ES <= E_ESPERA_BREAK;
                                    else
                                        ES <= E_INICIO;
                                    end if;
        when E_ESPERA_BREAK     =>  if break = '1' then
                                        ES <= E_COMPROBAR_TECLA;
                                    else
                                        ES <= E_ESPERA_BREAK;
                                    end if ;
        when E_COMPROBAR_TECLA  =>  if cod_eq_cod2 = '1' then
                                        ES <= E_INICIO;
                                    else
                                        ES <= E_ESPERA_BREAK;
                                    end if ;
        end case ;
    end process ;

-- UP
    -- Unidades Combinacionales
    cod_eq_cod2 <= '1' when cod = cod2 else '0';

    -- Unidades Secuenciales
    r_cod : process( clk, reset_l )
    begin
        if reset_l = '0' then
            cod <= X"00";
        elsif rising_edge(clk) then
            if ld_cod = '1' then
                cod <= codigo;
            end if ;
    end if ;
    end process ;

    r_cod2 : process( clk, reset_l )
    begin
        if reset_l = '0' then
            cod2 <= X"00";
        elsif rising_edge(clk) then
            if ld_cod2 = '1' then
                cod2 <= codigo;
            end if ;
    end if ;
    end process ;

    r_pulsado : process( clk, reset_l )
    begin
      if reset_l = '0' then
        pulsado_out <= '0';
      elsif rising_edge(clk) then
        if ld_pulsado = '1' then
            pulsado_out <= pulsado_in;
        end if ;
      end if ;
    end process ;

    -- Proceso de ejemplo para copypaste
    -- ej : process( clk, reset_l )
    -- begin
    --   if reset_l = '0' then
    --   elsif rising_edge(clk) then
    --  
    --   end if ;
    -- end process ;

end architecture ;
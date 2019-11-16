library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_control_tecla is
    port (
        clk        : in std_logic;
        reset_l    : in std_logic;
        fin        : in std_logic;
        codigo_in  : in std_logic_vector(7 downto 0);
        codigo_out : out std_logic_vector(7 downto 0);
        make       : out std_logic;
        break      : out std_logic
    ) ;
end tec_control_tecla ; 

architecture arch1 of tec_control_tecla is
    TYPE t_estado is (E_INICIO, E_LEER_TECLA, E_ESPERAR_CODIGO, E_MAKE, E_BREAK);
    signal EP, ES, ESTADO: t_estado;
    
    signal ld_cod: std_logic;
    signal cod_eq_f0: std_logic;

    signal codigo: std_logic_vector(7 downto 0);

begin   
-- UC
    --Salida
    make  <= '1' when EP = E_MAKE  else '0';
    break <= '1' when EP = E_BREAK else '0';
    codigo_out <= codigo;
    --Salida UP
    ld_cod <= '1' when (EP = E_INICIO and fin = '1') 
                    or (EP = E_ESPERAR_CODIGO and fin = '1') else '0';
    
    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
            EP <= E_INICIO;
        elsif rising_edge(clk) then
            EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados : process(EP, fin, cod_eq_f0)
    begin
        case EP is
        when E_INICIO           =>  if fin = '1' then
                                        ES <= E_LEER_TECLA;
                                    else
                                        ES <= E_INICIO;
                                    end if ;
        when E_LEER_TECLA       =>  if cod_eq_f0 = '1' then
                                        ES <= E_ESPERAR_CODIGO;
                                    else
                                        ES <= E_MAKE; 
                                    end if ;
        when E_ESPERAR_CODIGO   =>  if fin = '1' then
                                        ES <= E_BREAK;
                                    else
                                        ES <= E_ESPERAR_CODIGO;
                                    end if;
        when E_BREAK => ES <= E_INICIO;
        when E_MAKE => ES <= E_INICIO;
        end case ;
    end process ;

-- UP
    --Unidades Combinacionales
    cod_eq_f0 <= '1' when codigo = X"F0" else '0';

    --Unidades Secuenciales
    r_cod : process( clk, reset_l )
    begin
        if reset_l = '0' then
            codigo <= X"00";
        elsif rising_edge(clk) then
            if ld_cod = '1' then
                codigo <= codigo_in;
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
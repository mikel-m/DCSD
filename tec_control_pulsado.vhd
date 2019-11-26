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
    tecla   : out std_logic_vector(3 downto 0);
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

    constant K_A : std_logic_vector(7 downto 0):= X"1C";
    constant K_S : std_logic_vector(7 downto 0):= X"1B";
    constant K_D : std_logic_vector(7 downto 0):= X"23";
    constant K_F : std_logic_vector(7 downto 0):= X"2B";
    constant K_G : std_logic_vector(7 downto 0):= X"34";
    constant K_H : std_logic_vector(7 downto 0):= X"33";
    constant K_J : std_logic_vector(7 downto 0):= X"3B";
    
    constant K_X : std_logic_vector(7 downto 0):= X"22";
    constant K_C : std_logic_vector(7 downto 0):= X"21";
    constant K_Z : std_logic_vector(7 downto 0):= X"1A";
    constant K_V : std_logic_vector(7 downto 0):= X"2A";
    constant K_B : std_logic_vector(7 downto 0):= X"32";
    constant K_N : std_logic_vector(7 downto 0):= X"31";
    constant K_M : std_logic_vector(7 downto 0):= X"3A";

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

      tecla_case : process (cod)
      begin
        case cod is
            when K_A => tecla <= X"0";
            when K_S => tecla <= X"1";
            when K_D => tecla <= X"2";
            when K_F => tecla <= X"3";
            when K_G => tecla <= X"4";
            when K_H => tecla <= X"5";
            when K_J => tecla <= X"6";
            
            when K_Z => tecla <= X"7";
            when K_X => tecla <= X"8";
            when K_C => tecla <= X"9";
            when K_V => tecla <= X"A";
            when K_B => tecla <= X"B";
            when K_N => tecla <= X"C";
            when K_M => tecla <= X"D";

            when others => tecla <= X"0";
        end case;
      end process;  

end architecture ;
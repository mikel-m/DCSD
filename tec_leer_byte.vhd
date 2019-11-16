library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tec_leer_byte is
  port (
    clk     : in std_logic;
    reset_l : in std_logic;
    ps2_clk : in std_logic;
    ps2_dat : in std_logic;
    fin     : out std_logic;
    codigo  : out std_logic_vector(7 downto 0)
  ) ;
end tec_leer_byte ; 

architecture arch1 of tec_leer_byte is
    TYPE t_estado is (E_INICIO, E_ESPERA_START, E_CARGAR_BIT,E_ESPERA_1,
        E_ESPERA_2,E_ESPERA_3,E_ESPERAR_STOP,E_LECTURA_TERMINADA);
    signal EP, ES, ESTADO: t_estado;

    signal clk_ps2_prev: std_logic;
    signal clk_ps2_ch_down: std_logic;
    signal cont_eq_8: std_logic;

    signal cont: unsigned(3 downto 0);
    signal clr_cont: std_logic;
    signal cont_plus: std_logic;

    signal par: std_logic;
    signal ld_par: std_logic;
    signal dat_par: std_logic;
    signal ld_dat_par: std_logic;

    signal ld_codigo: std_logic;
    signal r_codigo_in: std_logic_vector(7 downto 0) ;
    signal r_codigo_out: std_logic_vector(7 downto 0) ;

begin
-- UC  
    --Salida
    codigo <= r_codigo_out;
    fin <= '1' when EP = E_LECTURA_TERMINADA else '0';

    -- Salida a UP
    clr_cont   <= '1' when EP = E_INICIO                       else '0';
    ld_par     <= '1' when EP = E_CARGAR_BIT and ps2_dat = '1' else '0';
    ld_codigo  <= '1' when EP = E_CARGAR_BIT                   else '0';
    cont_plus  <= '1' when EP = E_CARGAR_BIT                   else '0';
    ld_dat_par <= '1' when EP = E_ESPERA_3                     else '0';

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
        EP <= E_INICIO;
        elsif rising_edge(clk) then
        EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados : process( EP,clk_ps2_ch_down,cont_eq_8,dat_par, par, ps2_dat)
    begin
        case EP is
        when E_INICIO       =>  if clk_ps2_ch_down ='1' and ps2_dat ='0' then
                                    ES <= E_ESPERA_START;
                                else
                                    ES <= E_INICIO;
                                end if;
        when E_ESPERA_START =>  if clk_ps2_ch_down ='0' then
                                    ES <= E_ESPERA_START;
                                else
                                    ES <= E_CARGAR_BIT;
                                end if;
        when E_CARGAR_BIT   =>  if cont_eq_8='0' then
                                    ES<= E_ESPERA_2;
                                else
                                    ES<= E_ESPERA_1;
                                end if ;
        when E_ESPERA_1     =>  if clk_ps2_ch_down ='0' then
                                    ES <= E_ESPERA_1;
                                else
                                    ES <= E_ESPERA_3;
                                end if;
        when E_ESPERA_2     =>  if clk_ps2_ch_down ='0' then
                                    ES <= E_ESPERA_2;
                                else
                                    ES <= E_CARGAR_BIT;
                                end if;
        when E_ESPERA_3     =>  if dat_par=par then
                                    ES <= E_ESPERAR_STOP;
                                elsif dat_par=par then
                                    ES <= E_INICIO;
                                end if;
        when E_ESPERAR_STOP =>  if clk_ps2_ch_down ='0' then
                                    ES <= E_ESPERAR_STOP;
                                else
                                    ES <= E_LECTURA_TERMINADA;
                                end if;
        when E_LECTURA_TERMINADA => ES <= E_INICIO;
        end case ;
    end process ;

-- UP
    r_codigo_in <= ps2_dat & r_codigo_out(6 downto 0);
    -- Unidades Combinacionales
   
    -- Unidades Secuenciales
    clk_ps2_ch : process( clk, reset_l )
    begin
        if reset_l = '0' then
            clk_ps2_prev <= '0';
        elsif rising_edge(clk) then
            clk_ps2_prev <= ps2_clk;
        end if;
    end process ; 
    clk_ps2_ch_down <= (ps2_clk xor clk_ps2_prev) and clk_ps2_prev;
    
    --Registro código
    r_codigo : process( clk, reset_l )
    begin
      if reset_l = '0' then
        r_codigo_out <= X"00";
      elsif rising_edge(clk) then
          if ld_codigo = '1' then
            r_codigo_out <= r_codigo_in;
          end if ;
      end if ;
    end process ; -- r_1

    --Counter
    count_8 : process( clk, reset_l )
    begin
        if reset_l = '0' then
            cont <= to_unsigned(0,4);
        elsif rising_edge(clk) then
            if clr_cont = '1' then
                cont <= to_unsigned(0,4);
            elsif cont_plus = '1' then
                cont <= cont + 1;
            end if ;
        end if ;
    end process ; -- count_8

    r_par : process( clk,reset_l )
    begin
        if reset_l = '0' then
            par <= '0';
        elsif rising_edge(clk) then
            if ld_par = '1' then
                par <= not par;
            end if;        
        end if ;
    end process ; -- r_par
  
    r_dat_par : process( clk,reset_l )
    begin
        if reset_l = '0' then
            dat_par <= '0';
        elsif rising_edge(clk) then
            if ld_dat_par = '1' then
                dat_par <= ps2_dat;
            end if;        
        end if ;
    end process ; -- r_dat_par

    
end architecture ;
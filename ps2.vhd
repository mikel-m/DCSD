library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity ps2 is
  port (
    clk_ps2 : in std_logic;
    reset_l : in std_logic;
    clk     : in std_logic;
    pulsado : out std_logic;
    data    : in std_logic;
    enable  : out std_logic
  ) ;
end ps2 ; 

architecture arch1 of ps2 is
  TYPE estado is (E_INICIO, E_PRINCIPIO, E_ESPERA_START, E_CARGAR_BIT,E_ESPERA_1,
        E_ESPERA_2,E_ESPERA_3,E_ESPERAR_STOP,E_LECTURA_TERMINADA,E_INICIO_1,E_INICIO_2,E_INICIO_3);
 
SIGNAL EP, ES	: estado;
 --Cambios en el clk
  signal clk_ps2_prev     : std_logic;
  signal clk_ps2_ch_down : std_logic; 
-- Contador
  signal clr_cont  : std_logic;
  signal cont_plus : std_logic;
  signal cont : unsigned(3 downto 0);
  signal cont_eq_8  : std_logic;
--
  signal ld_dat_par : std_logic;
  signal dat_par : std_logic;
  signal ld_par : std_logic;
  signal par : std_logic;
  signal ld_regs  : std_logic;
  signal r_in : std_logic_vector(7 downto 0);  --TODO cambiar nombre a r_in
  signal r_out_0  : std_logic_vector(7 downto 0);-- r = register
  signal r_out_1  : std_logic_vector(7 downto 0);
  signal r_out_2  : std_logic_vector(7 downto 0);
  signal ld_r_0 : std_logic;
  signal ld_r_1 : std_logic;
  signal ld_r_2 : std_logic;
  signal ld_pulsado : std_logic;
  signal momento : unsigned(1 downto 0);
 
  signal pulsado_in: std_logic;
  --señales de ayuda
  signal parity_check: std_logic;

  --Señales de multiplexores (4 entradas de 8 bits)
  signal mux_out : std_logic_vector(7 downto 0);
  signal mux_in_0: std_logic_vector(7 downto 0);
  signal mux_in_1: std_logic_vector(7 downto 0);
  signal mux_in_2: std_logic_vector(7 downto 0);
  signal mux_in_3: std_logic_vector(7 downto 0);
  constant F0: std_logic_vector(7 downto 0) := B"1111_0000";
  --señales limpias, perfecto
  
  signal dat_l: std_logic;
  signal clk_ps2_l: std_logic;
begin
  dat_l <= data;
------------------------------------------------------
  --- Unidad de control
  UC : process( clk, reset_l )
  begin
    if reset_l = '0' then
      EP <= E_INICIO;
    elsif rising_edge(clk) then
      EP <= ES;
    end if ;
  end process ; -- UC
  
  maquina_de_estados : process( EP,clk_ps2_ch_down,cont_eq_8,momento,r_out_0,r_out_1,r_out_2)
  begin
    case EP is
      when E_INICIO => ES <= E_PRINCIPIO;
      when E_PRINCIPIO => if clk_ps2_ch_down ='0' and dat_l ='0'then
                            ES <= E_PRINCIPIO;
                        elsif clk_ps2_ch_down ='1' and dat_l ='0' then
                            ES <= E_ESPERA_START;
                        end if;
      when E_ESPERA_START => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_START;
                         elsif clk_ps2_ch_down ='1' then
                            ES <= E_CARGAR_BIT;
                         end if;
      when E_CARGAR_BIT => if cont_eq_8='0' then
                            ES<= E_ESPERA_2;
                         elsif cont_eq_8='1' then
                            ES<= E_ESPERA_1;
                        end if ;
      when E_ESPERA_1 => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_1;
                         elsif clk_ps2_ch_down ='1' then
                            ES <= E_ESPERA_3;
                         end if;
      when E_ESPERA_2 => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERA_2;
                        elsif clk_ps2_ch_down ='1' then
                            ES <= E_CARGAR_BIT;
                        end if;
      when E_ESPERA_3 => if dat_par=par then
                            ES <= E_ESPERAR_STOP;
                         elsif dat_par=par then
                            ES <= E_PRINCIPIO;
                         end if;
      when E_ESPERAR_STOP => if clk_ps2_ch_down ='0' then
                            ES <= E_ESPERAR_STOP;
                            elsif clk_ps2_ch_down ='1' then
                            ES <= E_LECTURA_TERMINADA;
                            end if;
     when E_LECTURA_TERMINADA => if momento = "01" and r_out_0=F0 then ---ARREGLAR todo esto, igualdades
                                ES <= E_PRINCIPIO;
                                elsif  momento = "01" and r_out_0/=F0 then--arreglar solo bien el ES
                                ES <= E_INICIO_2;
                                elsif  momento = "10" and r_out_1=F0 then--arreglar solo bien el ES
                                ES <= E_PRINCIPIO;
                                elsif  momento = "10" and r_out_1/=F0 then--arreglar solo bien el ES
                                ES <= E_INICIO_3;                          
                                elsif  momento = "11" and r_out_2=r_out_0 then--arreglar solo bien el ES
                                ES <= E_PRINCIPIO;                                       
                                elsif  momento = "11" and r_out_2/=r_out_0 then--arreglar solo bien el ES
                                ES <= E_INICIO_1; 
                                else 
                                ES <= E_INICIO;
                                end if;
      when E_INICIO_2 => ES <= E_PRINCIPIO;
      when E_INICIO_3 => ES <= E_PRINCIPIO;
      when E_INICIO_1 => ES <= E_PRINCIPIO;
    end case ;
 
  end process ; -- ESTSIG
------------------------------------------------------
  --- Unidad de Proceso
  --
  --Pulsacion de 1 a 0
  clk_ps2_ch : process( clk, reset_l )
  begin
	 if reset_l = '0' then
	     clk_ps2_prev <= '0';
   elsif rising_edge(clk) then
      if(clk_ps2_l = '1') then
        clk_ps2_prev <= '1';
      else
        clk_ps2_prev <= '0';
      end if ;
   end if;
  end process ; 
  clk_ps2_ch_down <= (clk_ps2_l xor clk_ps2_prev) and clk_ps2_prev;
  ----------------------------------------------------
  -- Pulsacion de 0 a 1
  

  --Shifters y eso (TODO: Cambiar por registros normales)
  r_in <= dat_l & mux_out(6 downto 0);

  lds : process( momento, ld_regs )
  begin
    if ld_regs = '1' then
      if momento = to_unsigned(1,2) then
        ld_r_0 <= '1';
        ld_r_1 <= '0';
        ld_r_2 <= '0';
      elsif momento = to_unsigned(2,2) then
        ld_r_0 <= '0';
        ld_r_1 <= '1';
        ld_r_2 <= '0';
      elsif momento = to_unsigned(3,2) then
        ld_r_0 <= '0';
        ld_r_1 <= '0';
        ld_r_2 <= '1';
      else
        ld_r_0 <= '0';
        ld_r_1 <= '0';
        ld_r_2 <= '0';
      end if;

    else
      ld_r_0 <= '0';
      ld_r_1 <= '0';
      ld_r_2 <= '0';
    end if ;
  end process ; -- lds
-- Unidades Combinacionales
  mux : process( momento, mux_in_0, mux_in_1, mux_in_2, mux_in_3 )
  begin
    case momento is
      when to_unsigned(0, 2) => mux_out <= mux_in_0;
      when to_unsigned(1, 2) => mux_out <= mux_in_1;
      when to_unsigned(2, 2) => mux_out <= mux_in_2;
      when to_unsigned(3, 2) => mux_out <= mux_in_3;
      when others => mux_out <= B"0000_0000";
    end case;
  end process ; -- mux


--- Unidades Secuenciales
  
  r_0 : process( clk, reset_l )
  begin
    if reset_l = '1' then
      r_out_0 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_r_0 = '1' then
          r_out_0 <= r_in;
        end if ;
    end if ;
  end process ; -- r_1
  

  r_1 : process( clk, reset_l )
  begin
    if reset_l = '0' then
      r_out_1 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_r_1 = '1' then
          r_out_1 <= r_in;
        end if ;
    end if ;
  end process ; -- r_1

  r_2 : process( clk, reset_l )
  begin
    if reset_l = '0' then
      r_out_2 <= B"0000_0000";
    elsif rising_edge(clk) then
        if ld_r_2 = '1' then
          r_out_2 <= r_in;
        end if ;
    end if ;
  end process ; -- r_2

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
      if ld_par = '1' then
        dat_par <= dat_l;
      end if;        
    end if ;
  end process ; -- r_par
  
  count_8 : process( clk,reset_l )
  begin
    if reset_l = '0' then
      cont <= to_unsigned(0,3);
    elsif rising_edge(clk) then
      if clr_cont = '1' then
        cont <= to_unsigned(0,3);
      elsif cont_plus = '1' then
        cont <= cont + 1;
      end if ;
    end if ;
  end process ; -- count_8
  
  r_pulsado : process( clk, reset_l )
  begin
    if reset_l = '0' then
      pulsado <= '0';
    elsif rising_edge(clk) then
      if ld_pulsado = '1' then
        pulsado <= pulsado_in;
      end if ;  
    end if ;
  end process ; -- r_pulsado

  -- -- Proceso de ejemplo para copypaste
  -- ej : process( clk, reset_l )
  -- begin
  --   if reset_l = '0' then
  --   elsif rising_edge(clk) then
      
  --   end if ;
  -- end process ;

  end architecture ;
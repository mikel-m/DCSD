library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity aud_control_volumen is
  port (
    clk : in std_logic;
    reset_l : in std_logic;
    vol_plus : in std_logic;
    vol_minus : in std_logic;
    vol : out std_logic_vector(3 downto 0)
  ) ;
end aud_control_volumen ; 

architecture arch1 of aud_control_volumen is
    TYPE t_estado is (E_INICIO, E_PLUS, E_MINUS);
    signal EP, ES: t_estado;
   
    signal vol_int       : unsigned(3 downto 0);
    signal vol_plus_int  : std_logic;
    signal vol_minus_int : std_logic;
begin
    vol <= std_logic_vector(vol_int);
    vol_plus_int  <= '1' when EP = E_PLUS else '0';
    vol_minus_int <= '1' when EP = E_MINUS else '0';

    est_pr : process( clk, reset_l )
    begin
        if reset_l = '0' then
            EP <= E_INICIO;
        elsif rising_edge(clk) then
            EP <= ES;
        end if ;
    end process ; -- est_pr
    ESTADO <= EP;

    maquina_de_estados : process(EP, vol_plus, vol_minus)
    begin
        case EP is
            when E_INICIO =>    if vol_plus = '1' then
                                    ES <= E_PLUS;
                                elsif vol_minus = '1' then
                                    ES <= E_MINUS;
                                else
                                    ES <= E_INICIO;
                                end if ;
            when E_PLUS =>  ES <= E_INICIO;
            when E_MINUS => ES <= E_INICIO;
        end case ;
    end process ;

    r_vol : process( clk, reset_l )
    begin
        if reset_l = '0' then
            vol <= X"7";
        elsif rising_edge(clk) then
                if vol_plus_int = '1' and vol /= X"F" then
                    vol <= vol + 1;
                elsif vol_minus_int = '1' and vol /= X"0" then
                    vol <= vol - 1;
                end if ;
        end if ;
    end process ; -- r_vol


end architecture ;
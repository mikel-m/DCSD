library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity div_freq is
  port (
    clk: in std_logic;
    reset_l : in std_logic;
    clk_div : out std_logic
  ) ;
end div_freq ; 

architecture arch1 of div_freq is
 signal clkcnt : unsigned(2 downto 0) ;
 signal clk_t : std_logic;
begin
    clk35 : process( clk, reset_l )
	begin
		if reset_l = '0' then
			clk_t <= '0';
			clkcnt <= (others => '0');
		elsif rising_edge(clk) then
			if clkcnt = "100" then
				clk_t <= not clk_t;
				clkcnt <= (others => '0');
			else
				clkcnt <= clkcnt+1;	
			end if ;
		end if ;
	end process ; -- clk35
    clk_div <= clk_t;
end architecture ;
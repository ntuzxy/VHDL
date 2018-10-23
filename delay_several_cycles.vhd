----------------------------------------------------------------------------------
-- Description: using left/right shift to delay
----------------------------------------------------------------------------------
library IEEE;
use std.textio.all;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

                             
entity sync_delay is           
    port (        
        clk           : in  std_logic;
        rst           : in  std_logic;
        en            : in  std_logic;
        rst_delay     : out  std_logic; 
        en_delay      : out  std_logic
    );
end sync_delay;

architecture behavioral of sync_delay is

--signal rst_delay    : std_logic := '1';
signal rst_array    : std_logic_vector(15 downto 0) := "1111111111111111";

--signal en_delay     : std_logic := '0';
signal en_array     : std_logic_vector(15 downto 0) := "0000000000000000";

begin

-- ***** sync resets *****
rst_delay   <= rst_array(rst_array'left); --delay 16 cycles
u_sync_rst : process(clk, rst)
begin
    if rst = '1' then
        rst_array <= (others => '1');
    else
        if rising_edge(clk) then
            rst_array <= rst_array(rst_array'left-1 downto 0) & "0";
        end if;
    end if;
end process u_sync_rst;


-- ***** sync enables *****
en_delay    <= en_array(3); --delay 4 cycles
u_sync_en: process(clk, rst, en)
begin
    if rst = '1' then
        en_array <= (others => '0');
    else
        if rising_edge(clk) then
            if en = '1' then
                en_array <= en_array(en_array'left-1 downto 0) & "1";
            end if;
        end if;
    end if;
end process u_sync_en;

end behavioral;


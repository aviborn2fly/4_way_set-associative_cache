----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2018 19:57:21
-- Design Name: 
-- Module Name: tb_cache_in - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_cache_in is
Port ( 
inst : in STD_LOGIC_VECTOR (11 downto 0);
odata : out STD_LOGIC_VECTOR (3 downto 0)
);
end tb_cache_in;

architecture Behavioral of tb_cache_in is
component cache_in is
Port (
inst : STD_LOGIC_VECTOR (11 downto 0);
odata : STD_LOGIC_VECTOR (3 downto 0)
);
end component cache_in;
signal inst1 : STD_LOGIC_VECTOR (11 downto 0) :="000000000000";
signal odata1 : STD_LOGIC_VECTOR (3 downto 0) :="0000";

begin

UUT: cache_in
Port map(
inst => inst1,
odata => odata1

);
inst1(5 downto 0) <= not inst1(5 downto 0) after 10 ns;
odata1<= not odata1 after 20 ns; 

end Behavioral;

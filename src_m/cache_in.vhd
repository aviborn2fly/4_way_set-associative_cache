----------------------------------------------------------------------------------
-- Company: 
-- Engineer: AVINASH
-- 
-- Create Date: 20.10.2018 14:06:32
-- Design Name: Set Associative Cache
-- Module Name: cache_in - Behavioral
-- Project Name: 4-Way Set Associative Cache Simulation
-- Target Devices: Artrix-7
-- Tool Versions: 2018.2
-- Description: 
--
-- 4-Way Set Associative Cache Simulation, addressing with 12 bit input 
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
 use IEEE.NUMERIC_STD.ALL;

use ieee.std_logic_unsigned.all;




-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cache_in is
    Port ( clk : in STD_LOGIC;
           inst : in STD_LOGIC_VECTOR (11 downto 0);
           --result : out STD_LOGIC_VECTOR (11 downto 0);
          -- result2 : out STD_LOGIC_VECTOR (9 DOWNTO 0);
           odata : out STD_LOGIC_VECTOR(3 downto 0));
           
            
end cache_in;

architecture Behavioral of cache_in is 

subtype cacheline is STD_LOGIC_VECTOR (9 downto 0);
type cache_datatype is array (0 to 15) of cacheline;
signal cache : cache_datatype ;
--here cache is an array having 16 lines of 10 bits each

signal irw,ilock : STD_LOGIC :='0'; 
-- irw defines read operation if 0 and write operation if 1
--ilock defines do not change lock if 0 and toggle lock if 1
         signal  iaddr : STD_LOGIC_VECTOR (5 DOWNTO 0) :="000000";
         --iaddr is the main memory address for the data
         signal  idata : STD_LOGIC_VECTOR (3 downto 0) :="0000";
         --idata is the data bits for a write operation
           signal itag : STD_LOGIC_VECTOR (3 downto 0) :="0000";
           signal iset : STD_LOGIC_VECTOR (1 downto 0):="00";
           signal temp : STD_LOGIC_VECTOR (3 downto 0):="0000";
           --temp is a temporary signal used for intermediate processing
           signal caddr : STD_LOGIC_VECTOR (3 DOWNTO 0):="0000";
           --caddr is used to refer a cache address for an operation
           signal taglock0,taglock1,taglock2,taglock3 : STD_LOGIC_VECTOR (0 to 0) := "0" ;
           --taglockX tells if the tag X is lock or not
           signal taglastset0,taglastset1,taglastset2,taglastset3 : STD_LOGIC_VECTOR (1 downto 0) := "00";
           --taglastsetX tells which set in the specific tag X is ready to be written or overwritten
           
         
          
        
           
           
begin

 irw <= inst(11);
 ilock <= inst(10);
 iaddr(5 downto 0) <= inst(9 downto 4);
 itag(1 downto 0)<= iaddr(3 downto 2);
 iset (1 downto 0)<= iaddr(1 downto 0);
 idata (3 downto 0)<= inst(3 downto 0);

 
 --result(11)<=irw;
 --result(10)<=ilock;
 --result(9 downto 4)<=iaddr;
-- result(3 downto 0)<=idata;
-- result2<=cache(0);
 
process(clk)
begin

caddr(3 downto 2)<=iset;
if (irw='0') then

--read data from the cache after comparing the address bit
    
    
    caddr(1 downto 0)<="00";
    if (iaddr=cache(to_integer(unsigned(caddr)))(9 downto 4)) then
     -- data found in set0
     --do read operation
       odata<=cache(to_integer(unsigned(caddr)))(3 downto 0);
      if(ilock='1') then
                   if(taglock0 ="0") then
                   taglock0<="1";
                   else 
                   taglock0<="0";
                  end if;
                   end if;
     else
    caddr(1 downto 0)<="01";
    end if;
    
     if (iaddr=cache(to_integer(unsigned(caddr)))(9 downto 4)) then
        -- data found in set1
       -- do read operation
          odata<=cache(to_integer(unsigned(caddr)))(3 downto 0);
          if(ilock='1') then
              if(taglock1 ="0") then
                            taglock1<="1";
                             else 
                             taglock1<="0";
                            end if;
               end if;
    else 
     caddr(1 downto 0)<="10";
     end if;
      
        if (iaddr=cache(to_integer(unsigned(caddr)))(9 downto 4)) then
             -- data found in set2
             --do read operation
             odata<=cache(to_integer(unsigned(caddr)))(3 downto 0);
              if(ilock='1') then
                            if(taglock2 ="0") then
                                taglock2<="1";
                                else 
                                taglock2<="0";
                               end if;
                         
                           end if;
       else 
        caddr(1 downto 0)<="11";
        end if;
       
           if (iaddr=cache(to_integer(unsigned(caddr)))(9 downto 4)) then
              -- data found in set3
              --do read operation
               odata<=cache(to_integer(unsigned(caddr)))(3 downto 0);
                 if(ilock='1') then
                               if(taglock3 ="0") then
                                   taglock3<="1";
                                   else 
                                  taglock3<="0";
                                  end if;
                            
                             end if;
          else 
         
          end if;
     

 else

--write operation
  if (iset="00") then
 
    if(taglock0="1") then 
       -- this tag is locked hence write operation will not be performed
       --write code to show that tag is locked 
    else 
       --check last set where previous write operation was performed
         caddr(1 downto 0)<=taglastset0;
   
        --write data to cache
        cache(to_integer(unsigned(caddr)))(9 downto 4) <= iaddr;
  
        cache(to_integer(unsigned(caddr)))(3 downto 0) <= idata;
    
        taglastset0 <= std_logic_vector(unsigned(taglastset0)) + 01;
    
  
   end if;
   else
    if (iset="01") then
            -- this tag is locked hence write operation will not be performed
      if(taglock1="1") then 
         -- end if;
      else 
        --check last set where previous write operation was performed
          caddr(1 downto 0)<=taglastset1;
     
           --write data to cache
          cache(to_integer(unsigned(caddr)))(9 downto 4) <= iaddr;
    
          cache(to_integer(unsigned(caddr)))(3 downto 0) <= idata;
      
          taglastset1 <= std_logic_vector(unsigned(taglastset1)) + 01;
      
    
     end if;
     else
      if (iset="10") then
     
        if(taglock2="1") then 
          -- this tag is locked hence write operation will not be performed
        else 
            --check last set where previous write operation was performed
            caddr(1 downto 0)<=taglastset2;
       
            --write data to cache
            cache(to_integer(unsigned(caddr)))(9 downto 4) <= iaddr;
      
            cache(to_integer(unsigned(caddr)))(3 downto 0) <= idata;
        
            taglastset2 <= std_logic_vector(unsigned(taglastset2)) + 01;
        
      
       end if;
       else
        if (iset="11") then
       
          if(taglock3="1") then 
             -- this tag is locked hence write operation will not be performed
          else 
            --check last set where previous write operation was performed
            caddr(1 downto 0)<=taglastset3;
                  --write data to cache
        
              cache(to_integer(unsigned(caddr)))(9 downto 4) <= iaddr;
        
              cache(to_integer(unsigned(caddr)))(3 downto 0) <= idata;
          
              taglastset3 <= std_logic_vector(unsigned(taglastset3)) + 01;
          
        
         end if;
          end if;
        end if;
      end if;
    end if;
 
 end if;
 end process;



end Behavioral

;

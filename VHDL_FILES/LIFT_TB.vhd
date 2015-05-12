LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY lift_tb IS
END lift_tb;
 
RCHITECTURE behavior OF lift_tb IS 
 
   -- Component Declaration for the Unit Under Test (UUT)
   -- fix this component for your design 
   COMPONENT lift
   PORT(
        clk : IN  std_logic;
        sensors : IN  std_logic_vector(4 downto 0);
        calls : IN  std_logic_vector(4 downto 0);
        menu : IN  std_logic_vector(4 downto 0);
        motor : OUT  std_logic_vector (1 downto 0);
        sleep : OUT  std_logic;
        ss : OUT  std_logic_vector(6 downto 0)
       );
   END COMPONENT;
    
  --Inputs
  signal clk : std_logic := '0';
  signal sensor : std_logic_vector(4 downto 0) := (others => '0');
  signal call : std_logic_vector(4 downto 0) := (others => '0');
 
   --Outputs
  signal motor : std_logic_vector(1 downto 0);
  signal menu  : std_logic_vector(4 downto 0);
  signal sleep : std_logic;
  signal ss : std_logic_vector(6 downto 0);
 
  -- internal signals and types
  signal counter : integer:=0 ; 
  type state is (f1,f12,f2,f23,f3,f34,f4); 
  signal current_floor : state; 
 
  -- Clock period definitions
  constant clk_period : time := 2 ns;
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
  uut: lift PORT MAP (
         clk => clk,
         sensors => sensor,
         calls => call,
         menu => menu,
         motor => motor,
         sleep => sleep,
         ss => ss
       );
 
  -- Clock process definitions
  clk_process :process
  begin
       clk <= '0';
       wait for clk_period/2;
       clk <= '1';
       wait for clk_period/2;
  end process;
  
  -- Stimulus process
  stim_proc: process
  begin        
               call   <= "00000";
               menu <= "00000";
 
     -- hold reset state for 100 ns.
     wait for 100 ns;  
     wait for clk_period*10;
 
     -- insert stimulus here 
               call   <= "00001";
               wait for clk_period;
               call   <= "00000";
  
               wait for clk_period*50;
 
               call   <= "00010";
               wait for clk_period;
               call   <= "00000";
               wait for clk_period*50;
 
               call   <= "00100";
               wait for clk_period;
               call   <= "00000";
               wait until sensor(2)= '1';
               wait for clk_period*40;
               call   <= "01000";
               wait for clk_period;
               call   <= "00000";
               wait until sensor(3)= '1';
               wait for clk_period*40;
 
               call   <= "00010";
               wait for clk_period;
               call   <= "00000";
               wait until sensor(1)= '1';
               wait for clk_period*40;
               call   <= "00001";
               wait for clk_period;
               call   <= "00000";
               wait until sensor(0) = '1';
               wait for clk_period*40;
               wait;
    end process;
       --  simple/stupid lift emulator
       process (motor(1)) begin
               if rising_edge(motor(1)) then
                       if sleep = '1' then
                               if motor(0) = '0' then
                                       counter <= counter +1;
                               elsif motor(0) = '1' then
                                       counter <= counter -1;
                               else
                                       assert false report "The motor feels lonely and ignored why are you not driving it properly" severity warning;
                               end if;
                       end if; -- sleep
               end if;-- motor)1)
       end process;
       --  Assert based on state on lift
       process (counter) begin
               if counter < 2 and counter >=0 then -- floor 1 ( last chance to stop for 1st floor)
                       sensor <="00001";
                       assert false report " 1st Floor "severity note;
               elsif counter < 3 and counter >=2 then -- between floor 1 and 2 sensors ( good place to stop either way for 1nd floor)            
                       sensor <="00000";    
                       if sleep = '1'  then --check if we are awake
                                 assert motor(0) /= '1' report " BLIND SPOT "severity note;
                                 assert motor(0) /= '0' report " BLIND SPOT  "severity note;
                       end if;
 
               elsif counter < 4 and counter >=3 then -- between floor 1 and 2 sensors ( good place to stop either way for 1nd floor)
                       sensor <="00011";
                       if sleep = '1'  then --check if we are awake
                               assert motor(0) /= '1' report " Just cut the bottom sensor for 1st floor, this is a good place to stop "severity note;
                               assert motor(0) /= '0' report " Just cut the bottom sensor for 2nd floor, keep going up  "severity note;
                       end if;
 
               elsif counter < 9 and counter >=4 then -- floor 2: for up : 1st cut of bottom   
                                                      -- floor 2: for down:  stop 
                       assert motor(0) /= '1' report " 2nd Floor "severity note;
                       assert motor(0) /= '0' report " floor 2: for up : 1st cut of sensor 1"severity note;                                       
                       sensor <="00010";
 
               elsif counter < 10 and counter >=9 then -- between the 2 and 3 sensors ( good place to stop either way for 2nd floor)
                       sensor <="00000";    
                       if sleep = '1'  then --check if we are awake
                              assert motor(0) /= '1' report " BLIND SPOT "severity note;
                              assert motor(0) /= '0' report " BLIND SPOT  "severity note;
                       end if;
 
               elsif counter < 11 and counter >=10 then -- between the 2 and 3 sensors ( good place to stop either way for 2nd floor)
                       sensor <="00110";            
                       if sleep = '1'  then --check if we are awake
                              assert motor(0) /= '1' report " Just cut the bottom sensor for 2nd floor, this is a good place to stop "severity note;
                              assert motor(0) /= '0' report " Just cut the bottom sensor for 3rd floor, keep going up  "severity note;
                       end if;
 
               elsif counter < 16 and counter >=11 then -- floor 3: for up : 1st cut of bottom   
                                                        -- floor 3: for down:  stop 
                       assert motor(0) /= '1' report " 3nd Floor "severity note;
                       assert motor(0) /= '0' report " floor 3: for up : 1st cut of sensor 2"severity note;                                       
                       sensor <="00100";
               elsif counter < 17 and counter >=16 then -- between the 3 and 4 sensors ( good place to stop either way for 3nd floor)
                       sensor <="00000";    
                       if sleep = '1'  then --check if we are awake
                              assert motor(0) /= '1' report " BLIND SPOT "severity note;
                              assert motor(0) /= '0' report " BLIND SPOT  "severity note;
                       end if;
               elsif counter < 18 and counter >=17 then -- between the 3 and 4 sensors ( good place to stop either way for 3nd floor)
                       sensor <="01100";    
                       if sleep = '1'  then --check if we are awake
                              assert motor(0) /= '1' report " Just cut the bottom sensor for 3rd floor, this is a good place to stop "severity note;
                              assert motor(0) /= '0' report " Just cut the bottom sensor for 4th floor, keep going up  "severity note;
                       end if;
               elsif counter < 23 and counter >=18 then -- floor 4: for up : 1st cut of bottom   
                                                        -- floor 4: for down:  stop 
                       assert motor(0) /= '1' report " 4nd Floor "severity note;
                       assert motor(0) /= '0' report " floor 4: for up : 1st cut of sensor 3"severity note;                                       
                       sensor <="01000";
               elsif counter < 24 and counter >=23 then -- between the 4 and 5 sensors ( good place to stop either way for 4nd floor)
                       sensor <="00000";    
                       if sleep = '1'  then --check if we are awake
                               assert motor(0) /= '1' report " BLIND SPOT "severity note;
                               assert motor(0) /= '0' report " BLIND SPOT  "severity note;
                       end if;
               elsif counter < 25 and counter >=24 then -- between the 4 and 5 sensors ( good place to stop either way for 4nd floor)
                       sensor <="11000";            
                       if sleep = '1'  then --check if we are awake
                               assert motor(0) /= '1' report " Just cut the bottom sensor for 4th floor, this is a good place to stop "severity note;
                               assert motor(0) /= '0' report " Getting  too close to the roof, 5th sensor is cut "severity warning;
                       end if;
               elsif counter < 30 and counter >=25 then -- floor 5: for up : 1st cut of bottom   
                                                        -- floor 5: for down:  stop                             
                       assert motor(0) /= '1' report " 5nd Floor "severity note;
                       assert motor(0) /= '0' report " ITS THE 5TH FLOOR ALREADY!!! STOP GOING UP "severity warning;                                       
                       sensor <="10000";
               elsif counter >33  then
                       assert false report "Hold on mi lord! this is an elevator not a Nazgûl, Elevators cant fly P.s. by now your passenger will be halfway through the roof saying hi to the seagulls " severity error;
               elsif counter < 0 then 
                       assert false report "Trying to go below 1st floor P.S. leave the Journey to the center of the earth to Jules Verne" severity error;
               end if;
      end process;
END;
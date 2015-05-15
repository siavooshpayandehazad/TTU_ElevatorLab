
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity wrapper is
    Port ( 
	clk : in std_logic;
	 top_sensor : in  STD_LOGIC;
	 bottom_sensor: in std_logic;
    fpga_clk : in  STD_LOGIC;
    fpga_sleep : in  STD_LOGIC;
    fpga_direction : in  STD_LOGIC;
    
    top_sensor_out : out  STD_LOGIC;
    motor_clk        : out  STD_LOGIC;
    motor_sleep     : out  STD_LOGIC;
    reset_to_controller: out STD_LOGIC;
    motor_direction : out  STD_LOGIC
);
end wrapper;

architecture Behavioral of wrapper is
signal  rst : std_logic;
signal counter : std_logic_vector (19 downto 0);
signal db1,db2,prev_counter,deb_bottom_sensor : std_logic;
begin
	top_sensor_out <= top_sensor;
	top_sensor_out <= top_sensor;
	process (top_sensor,fpga_clk,fpga_sleep,fpga_direction,rst,counter,deb_bottom_sensor)begin
		if rst = '0' then
			motor_clk <= fpga_clk;
			motor_sleep <=fpga_sleep;
			motor_direction <=fpga_direction and (not deb_bottom_sensor);
		else 
			motor_clk <= counter(10);
			motor_sleep <=  '1';
			motor_direction <= '1';
		end if;
	end process;
	
	process (clk) begin
	
		if rising_edge(clk) then
			counter <= counter +1;
			if top_sensor = '1' then 
				rst <= '1';
			elsif deb_bottom_sensor ='1' then
				rst <= '0';
			end if;
			
			prev_counter <= counter(19);
			if prev_counter = '0' and counter(19) = '1' then
				db1 <= bottom_sensor;
				db2 <= db1;
			end if;
		end if;
	end process;
	deb_bottom_sensor <= db1 and db2 and bottom_sensor;
	reset_to_controller <= rst;
	

end Behavioral;



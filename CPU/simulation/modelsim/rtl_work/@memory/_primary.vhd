library verilog;
use verilog.vl_types.all;
entity Memory is
    generic(
        ADDRESS_WIDTH   : integer := 32;
        SIZE            : integer := 256;
        INITIALIZATION_FILE: string  := "/home/jovan/quartusWorkspace/CPU/tests/binaryFiles/buttonInterrupt"
    );
    port(
        address         : in     vl_logic_vector;
        mio             : in     vl_logic;
        dataBusIn       : in     vl_logic_vector(7 downto 0);
        dataBusOut      : out    vl_logic_vector(7 downto 0);
        readRequest     : in     vl_logic;
        enable          : in     vl_logic;
        clock           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDRESS_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of INITIALIZATION_FILE : constant is 1;
end Memory;

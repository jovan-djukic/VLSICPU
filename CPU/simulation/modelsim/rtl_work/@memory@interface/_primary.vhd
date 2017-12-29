library verilog;
use verilog.vl_types.all;
entity MemoryInterface is
    generic(
        ADDRESS_BUS_WIDTH: integer := 32;
        DATA_WIDTH      : integer := 32;
        DATA_BUS_WIDTH  : integer := 8;
        CLOCK_COUNT_WIDTH: integer := 3
    );
    port(
        addressBus      : out    vl_logic_vector;
        dataBusIn       : in     vl_logic_vector;
        dataBusOut      : out    vl_logic_vector;
        mio             : out    vl_logic;
        readRequest     : out    vl_logic;
        enable          : out    vl_logic;
        clock           : in     vl_logic;
        address         : in     vl_logic_vector;
        dataIn          : in     vl_logic_vector;
        dataOut         : out    vl_logic_vector;
        isMemory        : in     vl_logic;
        readWrite       : in     vl_logic;
        clockCount      : in     vl_logic_vector;
        ready           : out    vl_logic;
        enableInterface : in     vl_logic;
        reset           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDRESS_BUS_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_BUS_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CLOCK_COUNT_WIDTH : constant is 1;
end MemoryInterface;

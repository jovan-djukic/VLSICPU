library verilog;
use verilog.vl_types.all;
entity InterruptPriorityEncoder is
    generic(
        WIDTH           : integer := 16;
        ADDRESS_WIDTH   : integer := 32;
        NUMBER_WIDTH    : integer := 4
    );
    port(
        externalInterrupts: in     vl_logic_vector;
        PSWI            : in     vl_logic;
        internalInterrupts: in     vl_logic_vector;
        address         : out    vl_logic_vector;
        interruptNumber : out    vl_logic_vector;
        interruptPresent: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDRESS_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of NUMBER_WIDTH : constant is 1;
end InterruptPriorityEncoder;

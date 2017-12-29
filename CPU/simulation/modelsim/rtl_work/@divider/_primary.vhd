library verilog;
use verilog.vl_types.all;
entity Divider is
    generic(
        WIDTH           : integer := 32;
        BIT_COUNTER_WIDTH: integer := 5
    );
    port(
        dividend        : in     vl_logic_vector;
        divider         : in     vl_logic_vector;
        start           : in     vl_logic;
        clock           : in     vl_logic;
        quotient        : out    vl_logic_vector;
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of BIT_COUNTER_WIDTH : constant is 1;
end Divider;

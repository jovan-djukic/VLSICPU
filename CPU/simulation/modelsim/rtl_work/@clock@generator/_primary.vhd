library verilog;
use verilog.vl_types.all;
entity ClockGenerator is
    generic(
        PERIOD          : integer := 10;
        DUTY_CYCLE      : integer := 5
    );
    port(
        clock           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
    attribute mti_svvh_generic_type of DUTY_CYCLE : constant is 1;
end ClockGenerator;

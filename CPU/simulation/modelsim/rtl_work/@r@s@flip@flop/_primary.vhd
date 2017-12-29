library verilog;
use verilog.vl_types.all;
entity RSFlipFlop is
    port(
        set             : in     vl_logic;
        reset           : in     vl_logic;
        clock           : in     vl_logic;
        q               : out    vl_logic
    );
end RSFlipFlop;

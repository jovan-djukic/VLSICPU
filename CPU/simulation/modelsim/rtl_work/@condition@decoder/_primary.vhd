library verilog;
use verilog.vl_types.all;
entity ConditionDecoder is
    port(
        condtionSelect  : in     vl_logic_vector(2 downto 0);
        zero            : in     vl_logic;
        carry           : in     vl_logic;
        negative        : in     vl_logic;
        overflow        : in     vl_logic;
        conditionSatisfied: out    vl_logic
    );
end ConditionDecoder;

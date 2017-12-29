library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        firstOperand    : in     vl_logic_vector(31 downto 0);
        secondOperand   : in     vl_logic_vector(31 downto 0);
        operation       : in     vl_logic_vector(3 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        carry           : out    vl_logic;
        overflow        : out    vl_logic;
        zero            : out    vl_logic;
        negative        : out    vl_logic
    );
end ALU;

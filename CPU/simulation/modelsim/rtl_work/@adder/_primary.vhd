library verilog;
use verilog.vl_types.all;
entity Adder is
    generic(
        WIDTH           : integer := 32
    );
    port(
        firstOperand    : in     vl_logic_vector;
        secondOperand   : in     vl_logic_vector;
        result          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end Adder;

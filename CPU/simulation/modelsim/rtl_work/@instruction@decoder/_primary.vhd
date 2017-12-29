library verilog;
use verilog.vl_types.all;
entity InstructionDecoder is
    port(
        IR              : in     vl_logic_vector(31 downto 0);
        ALUOperationCode: out    vl_logic_vector(3 downto 0);
        sourceA         : out    vl_logic_vector(4 downto 0);
        sourceB         : out    vl_logic_vector(4 downto 0);
        destination     : out    vl_logic_vector(4 downto 0);
        immediate       : out    vl_logic_vector(31 downto 0);
        isSecondImmediate: out    vl_logic;
        offset          : out    vl_logic_vector(31 downto 0);
        updatesZero     : out    vl_logic;
        updatesNegative : out    vl_logic;
        updatesCarry    : out    vl_logic;
        updatesOverflow : out    vl_logic;
        invalid         : out    vl_logic
    );
end InstructionDecoder;

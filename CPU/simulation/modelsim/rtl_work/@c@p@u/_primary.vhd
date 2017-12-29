library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        addressBus      : out    vl_logic_vector(31 downto 0);
        mio             : out    vl_logic;
        dataBusIn       : in     vl_logic_vector(7 downto 0);
        dataBusOut      : out    vl_logic_vector(7 downto 0);
        readRequest     : out    vl_logic;
        enable          : out    vl_logic;
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        externalInterrupts: in     vl_logic_vector(15 downto 0)
    );
end CPU;

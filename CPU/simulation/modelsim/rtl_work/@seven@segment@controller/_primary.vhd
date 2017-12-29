library verilog;
use verilog.vl_types.all;
entity SevenSegmentController is
    port(
        clock           : in     vl_logic;
        addressBus      : in     vl_logic_vector(31 downto 0);
        dataBusIn       : in     vl_logic_vector(7 downto 0);
        readWrite       : in     vl_logic;
        mio             : in     vl_logic;
        enable          : in     vl_logic;
        hex0            : out    vl_logic_vector(6 downto 0);
        hex1            : out    vl_logic_vector(6 downto 0);
        hex2            : out    vl_logic_vector(6 downto 0);
        hex3            : out    vl_logic_vector(6 downto 0)
    );
end SevenSegmentController;

library verilog;
use verilog.vl_types.all;
entity LedController is
    port(
        addressBus      : in     vl_logic_vector(31 downto 0);
        dataBusIn       : in     vl_logic_vector(7 downto 0);
        readRequest     : in     vl_logic;
        mio             : in     vl_logic;
        enable          : in     vl_logic;
        clock           : in     vl_logic;
        ledState        : out    vl_logic_vector(7 downto 0)
    );
end LedController;

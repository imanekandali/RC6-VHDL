LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RC6_Testbench IS
END RC6_Testbench;

ARCHITECTURE behavior OF RC6_Testbench IS 

    -- Signal declarations
    SIGNAL clk, reset, enable: std_logic;
    SIGNAL key, plaintext, ciphertext, decrypted_text: std_logic_vector(127 downto 0);
    SIGNAL ready_enc, ready_dec: std_logic;

    -- Component declarations
    COMPONENT RC6_Encrypt
    PORT(
        clk         : IN  std_logic;
        reset       : IN  std_logic;
        enable      : IN  std_logic;
        key         : IN  std_logic_vector(127 downto 0);
        plaintext   : IN  std_logic_vector(127 downto 0);
        ciphertext  : OUT std_logic_vector(127 downto 0);
        ready       : OUT std_logic
    );
    END COMPONENT;

    COMPONENT RC6_Decrypt
    PORT(
        clk         : IN  std_logic;
        reset       : IN  std_logic;
        enable      : IN  std_logic;
        key         : IN  std_logic_vector(127 downto 0);
        ciphertext  : IN  std_logic_vector(127 downto 0);
        plaintext   : OUT std_logic_vector(127 downto 0);
        ready       : OUT std_logic
    );
    END COMPONENT;

BEGIN

    -- UUT: Unit Under Test for Encryption
    uut_enc: COMPONENT RC6_Encrypt
        PORT MAP(
            clk => clk,
            reset => reset,
            enable => enable,
            key => key,
            plaintext => plaintext,
            ciphertext => ciphertext,
            ready => ready_enc
        );

    -- UUT: Unit Under Test for Decryption
    uut_dec: COMPONENT RC6_Decrypt
        PORT MAP(
            clk => clk,
            reset => reset,
            enable => enable,
            key => key,
            ciphertext => ciphertext,
            plaintext => decrypted_text,
            ready => ready_dec
        );

    -- Clock process definitions
    clk_process :PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10 ns;
        clk <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN        
        -- Initialization
        reset <= '1';
        key <= X"0123456789ABCDEF0123456789ABCDEF";  -- Example key
        plaintext <= X"00112233445566778899AABBCCDDEEFF";  -- Example plaintext
        enable <= '0';
        WAIT FOR 40 ns;
        
        reset <= '0';
        WAIT FOR 20 ns;
        
        -- Start Encryption
        enable <= '1';
        WAIT FOR 20 ns;
        
        enable <= '0';
        WAIT FOR 100 ns;

        -- Start Decryption
        enable <= '1';
        WAIT FOR 20 ns;
        
        enable <= '0';
        WAIT FOR 100 ns;

        -- Check if decrypted text matches original plaintext
        ASSERT decrypted_text = plaintext REPORT "Decryption failed" SEVERITY failure;

        WAIT;
    END PROCESS;

END behavior;

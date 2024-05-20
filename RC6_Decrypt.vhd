library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RC6_Decrypt is
    port (
        clk           : in  std_logic;        -- Clock signal
        reset         : in  std_logic;        -- Reset signal
        enable        : in  std_logic;        -- Enable decryption
        key           : in  std_logic_vector(127 downto 0); -- 128-bit key input
        ciphertext    : in  std_logic_vector(127 downto 0); -- 128-bit ciphertext input
        plaintext     : out std_logic_vector(127 downto 0); -- 128-bit plaintext output
        ready         : out std_logic         -- Indicates when decryption is complete
    );
end RC6_Decrypt;

architecture Behavioral of RC6_Decrypt is
    signal rkey : std_logic_vector(127 downto 0); -- Rotated key storage
    signal a, b, c, d : std_logic_vector(31 downto 0); -- Data registers for decryption
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset internal signals
            a <= (others => '0');
            b <= (others => '0');
            c <= (others => '0');
            d <= (others => '0');
            ready <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                -- Placeholder for key scheduling (Reverse order and operations)
                rkey <= key; -- Simplified placeholder

                -- Decryption operations (Reverse of encryption)
                d <= std_logic_vector(unsigned(d) xor unsigned(rkey(127 downto 96)));
                c <= std_logic_vector(unsigned(c) - unsigned(rkey(95 downto 64)));
                b <= std_logic_vector(unsigned(b) xor unsigned(rkey(63 downto 32)));
                a <= std_logic_vector(unsigned(a) - unsigned(rkey(31 downto 0)));

                -- Indicate decryption complete
                ready <= '1';
            else
                ready <= '0';
            end if;
        end if;
    end process;
end Behavioral;

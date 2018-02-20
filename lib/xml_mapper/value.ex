defmodule XMLMapper.Value do
  def escape(string) when is_binary(string) do
    string
    |> escape(string, 0, 1, [])
    |> IO.iodata_to_binary
  end
  def escape(data), do: data

  escapes = [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&apos;"}
  ]

  for {char, swap} <- escapes do
    def escape(<<unquote(char), rest::bits>>, string, start, length, acc) do
      skipped = binary_part(string, start, length - 1)
      escape(rest, string, start + length, 1, [acc, skipped | unquote(swap)])
    end
  end

  def escape(<<_char, rest::bits>>, string, start, length, acc) do
    escape(rest, string, start, length + 1, acc)
  end

  def escape(<<>>, string, start, length, acc) do
    [acc | binary_part(string, start, length - 1)]
  end
end

defmodule XMLMapper.Type do
  def cast(type, value, opts \\ [])
  def cast(:integer, value, _opts) do
    try do
      value
      |> to_string
      |> Integer.parse
      |> elem(0)
    rescue
      _ -> nil
    end
  end
  def cast(:float, value, _opts) do
    try do
      value
      |> to_string
      |> Float.parse
      |> elem(0)
    rescue
      _ -> nil
    end
  end
  def cast(:text, value, _opts) do
    value
    |> to_string
  end
  def cast(:naive_datetime, value, _opts) do
    value
    |> to_string
    |> NaiveDateTime.from_iso8601
    |> elem(1)
  end
  def cast(:datetime, value, _opts) do
    value
    |> to_string
    |> DateTime.from_iso8601
    |> elem(1)
  end
  def cast(:boolean, value, _opts) do
    "#{value}" == "true"
  end
  def cast(module, value, opts) do
    module.parse(value, %{})
    if opts[:multi] && opts[:without_root] != true do
      Enum.map(value, fn(tuple) ->
        module.parse(tuple)
      end)
    else
      module.parse(value, %{})
    end
  end
end

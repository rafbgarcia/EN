defmodule Filter do
  def matches?(item, filters) when is_map(item) and is_map(filters) do
    filters
    |> Enum.all?(&matches?(item, &1))
  end

  def matches?(item, filter) when is_map(item) and is_tuple(filter) and tuple_size(filter) == 2 do
    {criteria, value} = filter
    [field, matcher] = String.split(criteria, "__")

    match?(matcher, item[field], value)
  end

  defp match?(_, _, nil), do: false
  defp match?(_, nil, _), do: false

  defp match?("eq", left, right) when is_binary(left) and is_binary(right) do
    String.match?(left, ~r/^#{right}$/i)
  end

  defp match?("cont", left, right) when is_binary(left) and is_binary(right) do
    String.match?(left, ~r/#{right}/i)
  end

  defp match?("start", left, right) when is_binary(left) and is_binary(right) do
    String.match?(left, ~r/^#{right}/i)
  end
end

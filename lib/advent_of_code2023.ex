defmodule AdventOfCode2023 do
  @moduledoc false

  @spec is_digit(char :: String.t()) :: boolean()
  def is_digit(<<character>>), do: character >= ?0 and character <= ?9
end

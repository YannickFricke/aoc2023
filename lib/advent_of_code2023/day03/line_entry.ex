defmodule AdventOfCode2023.Day03.LineEntry do
  @moduledoc false

  @type entry_type() :: :number | :symbol

  @type t() :: %__MODULE__{
          type: entry_type(),
          line_index: non_neg_integer(),
          start_index: non_neg_integer(),
          content: String.t()
        }

  defstruct [:type, :line_index, :start_index, :content]

  @spec new(
          type :: entry_type(),
          line_index :: non_neg_integer(),
          start_index :: non_neg_integer(),
          content :: String.t()
        ) :: t()
  defp new(type, line_index, start_index, content),
    do: %__MODULE__{type: type, line_index: line_index, start_index: start_index, content: content}

  @spec new_number(
          start_index :: non_neg_integer(),
          line_index :: non_neg_integer(),
          content :: String.t()
        ) :: t()
  def new_number(line_index, start_index, character), do: new(:number, line_index, start_index, character)

  @spec new_symbol(
          start_index :: non_neg_integer(),
          line_index :: non_neg_integer(),
          content :: String.t()
        ) :: t()
  def new_symbol(line_index, start_index, character), do: new(:symbol, line_index, start_index, character)

  @spec append_character(
          entry :: t(),
          character_to_add :: String.t()
        ) :: t()
  def append_character(%__MODULE__{content: content} = entry, character_to_add),
    do: %__MODULE__{entry | content: content <> character_to_add}
end

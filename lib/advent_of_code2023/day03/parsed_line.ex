defmodule AdventOfCode2023.Day03.ParsedLine do
  @moduledoc false
  alias AdventOfCode2023.Day03.LineEntry

  @type t() :: %__MODULE__{
          line: String.t(),
          entries: list(LineEntry.t())
        }

  defstruct [:line, :entries]

  @spec parse_line({line :: String.t(), line_index :: non_neg_integer()}) :: t()
  def parse_line({line, line_index}) do
    {parsed_entries, acc} =
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce({[], nil}, fn {character, index}, {found_entries, current_entry} ->
        cond do
          character == "." ->
            # Dots are ignored

            if current_entry == nil do
              {found_entries, current_entry}
            else
              {found_entries ++ [current_entry], nil}
            end

          AdventOfCode2023.is_digit(character) ->
            case current_entry do
              nil ->
                {found_entries, LineEntry.new_number(line_index, index, character)}

              %LineEntry{type: :number} ->
                updated_entry = LineEntry.append_character(current_entry, character)

                {found_entries, updated_entry}
            end

          true ->
            # Character is a symbol

            symbol_entry = LineEntry.new_symbol(line_index, index, character)

            if current_entry == nil do
              {found_entries ++ [symbol_entry], nil}
            else
              {found_entries ++ [current_entry, symbol_entry], nil}
            end
        end
      end)

    parsed_entries =
      if acc != nil do
        parsed_entries ++ [acc]
      else
        parsed_entries
      end

    %__MODULE__{
      line: line,
      entries: parsed_entries
    }
  end

  def dump(%__MODULE__{line: line, entries: entries}) do
    amount_of_entries = length(entries)
    reversed_entries = Enum.reverse(entries)

    entries_indexes = Enum.map(entries, & &1.start_index)

    line_meta =
      reversed_entries
      |> Enum.with_index(1)
      |> Enum.map_join("\n", fn {%LineEntry{start_index: entry_start_index, type: entry_type}, index} ->
        bar_indexes = Enum.slice(entries_indexes, 0, amount_of_entries - index)

        other_bars =
          Enum.reduce(bar_indexes, "", fn bar_index, bar_acc ->
            spaces_to_print = bar_index - String.length(bar_acc)

            bar_acc <> String.duplicate(" ", spaces_to_print) <> "│"
          end)

        spaces_to_print = entry_start_index - String.length(other_bars)

        other_bars <> String.duplicate(" ", spaces_to_print) <> "└ #{entry_type} (index: #{entry_start_index})"
      end)

    line <> "\n" <> line_meta
  end
end

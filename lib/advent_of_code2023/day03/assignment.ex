defmodule AdventOfCode2023.Day03.Assignment do
  @moduledoc false
  alias AdventOfCode2023.Day03.LineEntry
  alias AdventOfCode2023.Day03.ParsedLine

  require IEx
  require Logger

  def run do
    input =
      "lib/advent_of_code2023/inputs/03/part1.txt"
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)

    part1(input)
    part2(input)
  end

  defp part1(lines) do
    parsed_lines =
      lines
      |> Enum.with_index()
      |> Enum.map(&AdventOfCode2023.Day03.ParsedLine.parse_line/1)

    possible_positions =
      parsed_lines
      |> Enum.flat_map(& &1.entries)
      |> Enum.filter(&(&1.type == :symbol))
      |> calculate_possible_positions()

    valid_part_numbers =
      parsed_lines
      |> Enum.flat_map(& &1.entries)
      |> Enum.filter(&(&1.type == :number))
      |> Enum.filter(fn %LineEntry{line_index: entry_line_index, start_index: entry_start_index, content: entry_content} =
                          entry ->
        Enum.any?(possible_positions, fn {position_line_index, position_index} ->
          entry_line_index == position_line_index and position_index >= entry_start_index and
            position_index < entry_start_index + String.length(entry_content)
        end)
      end)

    sum_of_part_numbers =
      valid_part_numbers
      |> Enum.map(&String.to_integer(&1.content))
      |> Enum.sum()

    Logger.info("Sum of part numbers: #{sum_of_part_numbers}")

    # dump_to_file(parsed_lines)
    # dump_to_console(parsed_lines, valid_part_numbers)
  end

  defp part2(lines) do
    parsed_lines =
      lines
      |> Enum.with_index()
      |> Enum.map(&AdventOfCode2023.Day03.ParsedLine.parse_line/1)

    possible_positions =
      parsed_lines
      |> Enum.flat_map(& &1.entries)
      |> Enum.filter(&(&1.type == :symbol and &1.content == "*"))
      |> calculate_possible_positions(false)

    numeric_entries =
      parsed_lines
      |> Enum.flat_map(& &1.entries)
      |> Enum.filter(&(&1.type == :number))

    result =
      possible_positions
      |> Enum.map(fn positions_entry ->
        positions_entry
        |> Enum.map(fn {position_line_index, position_index} ->
          Enum.filter(numeric_entries, fn %LineEntry{
                                            line_index: entry_line_index,
                                            start_index: entry_start_index,
                                            content: entry_content
                                          } ->
            entry_line_index == position_line_index and position_index >= entry_start_index and
              position_index < entry_start_index + String.length(entry_content)
          end)
        end)
        |> Enum.uniq()
        |> List.flatten()
      end)
      |> Enum.filter(&(length(&1) >= 2))
      |> Enum.map(fn entries ->
        entries
        |> Enum.map(&String.to_integer(&1.content))
        |> Enum.reduce(1, &(&1 * &2))
      end)
      |> Enum.sum()

    Logger.info("Part 2: #{result}")
  end

  defp calculate_possible_positions(symbol_entries, flatten \\ true) do
    possible_positions =
      Enum.map(symbol_entries, fn %LineEntry{line_index: line_index, start_index: start_index} = entry ->
        [
          # diagonal top left
          {line_index - 1, start_index - 1},
          # Adjacent top
          {line_index - 1, start_index},
          # diagonal top right
          {line_index - 1, start_index + 1},
          # Adjacent left
          {line_index, start_index - 1},
          # Adjacent right
          {line_index, start_index + 1},
          # diagonal bottom left
          {line_index + 1, start_index - 1},
          # Adjacent bottom
          {line_index + 1, start_index},
          # diagonal bottom right
          {line_index + 1, start_index + 1}
        ]
      end)

    if flatten do
      List.flatten(possible_positions)
    else
      possible_positions
    end
  end

  defp dump_to_file(parsed_lines, file_name \\ "day03_dump.txt") do
    file_contents =
      Enum.map_join(parsed_lines, "\n\n", &AdventOfCode2023.Day03.ParsedLine.dump/1)

    File.write!(file_name, file_contents)
  end

  defp dump_to_console(parsed_lines, valid_part_numbers) do
    Enum.each(parsed_lines, fn %ParsedLine{line: line, entries: line_entries} ->
      {line_to_print, line_without_ansi} =
        Enum.reduce(line_entries, {"", ""}, fn %LineEntry{
                                                 type: line_entry_type,
                                                 start_index: entry_start_index,
                                                 content: line_entry_content
                                               } = entry,
                                               {acc, acc_without_ansi} ->
          amount_of_dots_before_entry = entry_start_index - String.length(acc_without_ansi)
          dots_before_entry = String.duplicate(".", amount_of_dots_before_entry)

          case line_entry_type do
            :symbol ->
              {acc <>
                 dots_before_entry <>
                 IO.ANSI.yellow() <> line_entry_content <> IO.ANSI.reset(),
               acc_without_ansi <> dots_before_entry <> line_entry_content}

            :number ->
              ansi_color =
                if Enum.member?(valid_part_numbers, entry) do
                  IO.ANSI.green()
                else
                  IO.ANSI.red()
                end

              {acc <> dots_before_entry <> ansi_color <> line_entry_content <> IO.ANSI.reset(),
               acc_without_ansi <> dots_before_entry <> line_entry_content}
          end
        end)

      line_to_print = line_to_print <> String.duplicate(".", String.length(line) - String.length(line_without_ansi))

      IO.puts(line_to_print)
    end)
  end
end

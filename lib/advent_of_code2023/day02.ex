defmodule AdventOfCode2023.Day02 do
  @moduledoc false

  require Logger

  def run do
    input =
      "lib/advent_of_code2023/inputs/02/part1.txt"
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)

    part1(input)
    part2(input)
  end

  defp part1(input) do
    expected = %{
      "red" => 12,
      "green" => 13,
      "blue" => 14
    }

    sum_of_game_ids =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.map(fn {raw_game_id, subsets} ->
        parsed_game_id = String.to_integer(raw_game_id)

        {parsed_game_id, map_to_highest_colors(subsets)}
      end)
      |> Enum.filter(fn {_game_id, highest_colors} ->
        less_or_equal_red = Map.get(highest_colors, "red", 0) <= Map.get(expected, "red")
        less_or_equal_green = Map.get(highest_colors, "green", 0) <= Map.get(expected, "green")
        less_or_equal_blue = Map.get(highest_colors, "blue", 0) <= Map.get(expected, "blue")

        less_or_equal_red and less_or_equal_green and less_or_equal_blue
      end)
      |> Enum.map(fn {game_id, _highest_numbers} -> game_id end)
      |> Enum.sum()

    Logger.info("Part 1: #{sum_of_game_ids}")
  end

  defp part2(input) do
    power_of_sets =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.map(fn {_game_id, subsets} ->
        map_to_highest_colors(subsets)
      end)
      |> Enum.map(&Map.values/1)
      |> Enum.map(fn entry ->
        Enum.reduce(entry, fn value, acc -> acc * value end)
      end)
      |> Enum.sum()

    Logger.info("Part 2: #{power_of_sets}")
  end

  defp parse_line(line) do
    ["Game " <> game_id, cube_subsets] =
      String.split(line, ":", parts: 2, trim: true)

    all_subsets =
      cube_subsets
      |> String.split(";", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, ~r/, ?/))

    {game_id, all_subsets}
  end

  defp map_to_highest_colors(subsets) do
    subsets
    |> Enum.map(fn subset ->
      Map.new(subset, fn subset_entry ->
        [raw_amount, color] = String.split(subset_entry, " ", trim: true)
        parsed_amount = String.to_integer(raw_amount)

        {color, parsed_amount}
      end)
    end)
    |> Enum.reduce(%{}, fn mapped_subset, acc ->
      mapped_subset
      |> Map.keys()
      |> Enum.reduce(acc, fn map_key, acc ->
        current_number = Map.get(mapped_subset, map_key)

        Map.update(acc, map_key, current_number, &max(&1, current_number))
      end)
    end)
  end
end

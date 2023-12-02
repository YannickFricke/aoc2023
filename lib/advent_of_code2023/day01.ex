defmodule AdventOfCode2023.Day01 do
  def run() do
    part1()
    part2()
  end

  defp part1() do
    File.read!("lib/advent_of_code2023/inputs/01/part1.txt")
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_digits/1)
    |> Enum.reduce(0, &Kernel.+/2)
    |> IO.inspect(label: "Result part 1")
  end

  defp part2() do
    File.read!("lib/advent_of_code2023/inputs/01/part1.txt")
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&replace_stringified_digits/1)
    |> Enum.map(&process_digits/1)
    |> Enum.reduce(0, &Kernel.+/2)
    |> IO.inspect(label: "Result part 2")
  end

  defp is_digit(character), do: Enum.member?(~w(0 1 2 3 4 5 6 7 8 9), character)

  defp process_digits(line) do
    splitted_line = String.split(line, "", trim: true)

    first_digit =
      splitted_line
      |> Enum.drop_while(&(not is_digit(&1)))
      |> List.first()

    last_digit =
      splitted_line
      |> Enum.reverse()
      |> Enum.drop_while(&(not is_digit(&1)))
      |> List.first()

    [first_digit, last_digit]
    |> Enum.join("")
    |> String.to_integer()
  end

  @spec replace_stringified_digits(input :: String.t()) :: String.t()
  defp replace_stringified_digits(input) do
    input
    |> String.replace("one", "one1one")
    |> String.replace("two", "two2two")
    |> String.replace("three", "three3three")
    |> String.replace("four", "four4four")
    |> String.replace("five", "five5five")
    |> String.replace("six", "six6six")
    |> String.replace("seven", "seven7seven")
    |> String.replace("eight", "eight8eight")
    |> String.replace("nine", "nine9nine")
  end
end

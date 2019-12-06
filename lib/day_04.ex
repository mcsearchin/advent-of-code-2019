defmodule Day04 do
  def get_possible_password_count(range) do
    range |> Enum.filter(&meets_criteria?/1) |> length()
  end

  def get_more_specific_possible_password_count(range) do
    range |> Enum.filter(&meets_better_criteria?/1) |> length()
  end

  defp meets_criteria?(number) do
    possible_password = Integer.to_string(number) |> String.to_charlist()
    has_ascending_characters?(possible_password) && has_repeating_characters?(possible_password)
  end

  defp meets_better_criteria?(number) do
    possible_password = Integer.to_string(number) |> String.to_charlist()

    has_ascending_characters?(possible_password) &&
      has_exactly_two_repeating_characters?(possible_password)
  end

  defp has_ascending_characters?(chars) when length(chars) < 2, do: true

  defp has_ascending_characters?([first | rest]) do
    [next | _] = rest

    if next < first, do: false, else: has_ascending_characters?(rest)
  end

  defp has_repeating_characters?(chars) when length(chars) < 2, do: false

  defp has_repeating_characters?([first | rest]) do
    [next | _] = rest

    if first == next, do: true, else: has_repeating_characters?(rest)
  end

  defp has_exactly_two_repeating_characters?(chars) when length(chars) < 2, do: false

  defp has_exactly_two_repeating_characters?(chars) do
    count = count_repeating(chars)

    if count == 2 do
      true
    else
      {_counted, rest} = Enum.split(chars, count)
      has_exactly_two_repeating_characters?(rest)
    end
  end

  defp count_repeating(chars, count \\ 1)

  defp count_repeating(chars, count) when length(chars) < 2, do: count

  defp count_repeating([first | rest], count) do
    [next | _] = rest

    if first == next, do: count_repeating(rest, count + 1), else: count
  end
end

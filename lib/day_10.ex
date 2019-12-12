defmodule Day10 do
  defmodule Location do
    @enforce_keys [:x, :y]
    defstruct [:x, :y]
  end

  def get_max_asteroid_view_count(input) do
    locations = get_all_asteroid_locations(input)

    locations
    |> Enum.map(fn location -> get_view_count(location, locations) end)
    |> Enum.max()
  end

  defp get_all_asteroid_locations(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == ?# end)
      |> Enum.map(fn {_, x} ->
        %Location{x: x, y: y}
      end)
    end)
    |> Enum.flat_map(& &1)
  end

  defp get_view_count(location, all_locations) do
    relative_locations =
      all_locations
      |> excluding(location)
      |> Enum.map(&get_relative_location(location, &1))

    relative_locations
    |> get_visible_locations()
    |> length()
  end

  defp get_relative_location(location, other_location) do
    %Location{x: other_location.x - location.x, y: other_location.y - location.y}
  end

  defp get_visible_locations(relative_locations) do
    relative_locations
    |> Enum.reduce([], fn location, acc ->
      if location_visible?(location, relative_locations), do: [location | acc], else: acc
    end)
  end

  defp location_visible?(location, locations) do
    !(locations
      |> excluding(location)
      |> Enum.any?(&blocks?(location, &1)))
  end

  def blocks?(location, potential_blocker) do
    cond do
      potential_blocker.x == 0 ->
        location.x == 0 && Enum.member?(0..location.y, potential_blocker.y)

      potential_blocker.y == 0 ->
        location.y == 0 && Enum.member?(0..location.x, potential_blocker.x)

      signs_match?(location, potential_blocker) ->
        x_ratio = location.x / potential_blocker.x
        y_ratio = location.y / potential_blocker.y
        abs(x_ratio) > 1 && x_ratio == y_ratio

      true ->
        false
    end
  end

  defp signs_match?(location_1, location_2) do
    (location_1.x > 0 && location_2.x > 0) ||
      (location_1.x < 0 && location_2.x < 0) ||
      (location_1.y > 0 && location_2.y > 0) ||
      (location_1.y < 0 && location_2.y < 0)
  end

  defp excluding(collection, thing) do
    Enum.filter(collection, &(&1 != thing))
  end
end

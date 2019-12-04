defmodule Day03 do
  defmodule Line do
    @enforce_keys [:start, :end]
    defstruct [:start, :end]
  end

  defmodule Point do
    @enforce_keys [:x, :y]
    defstruct [:x, :y]
  end

  def find_closest_intersection_distance(path_1, path_2) do
    path_1_lines = parse_lines(path_1)
    path_2_lines = parse_lines(path_2)

    get_all_valid_intersections(path_1_lines, path_2_lines)
    |> Enum.map(&distance_to_center/1)
    |> Enum.min()
  end

  def find_shortest_paths_intersection_distance(path_1, path_2) do
    path_1_lines = parse_lines(path_1) |> Enum.reverse()
    path_2_lines = parse_lines(path_2) |> Enum.reverse()

    get_all_valid_intersections(path_1_lines, path_2_lines)
    |> get_summed_distances_to_intersections(path_1_lines, path_2_lines)
    |> Enum.min()
  end

  defp parse_lines(path) do
    instructions = String.split(path, ",")

    next_line(%Point{x: 0, y: 0}, instructions, [])
  end

  defp next_line(_location, [], acc), do: acc

  defp next_line(location, [next_instruction | remaining], acc) do
    line = %Line{
      start: location,
      end: get_line_end(location, next_instruction)
    }

    next_line(line.end, remaining, [line | acc])
  end

  defp get_line_end(location, instruction) do
    {direction, rest} = String.split_at(instruction, 1)
    {length, ""} = Integer.parse(rest)

    case direction do
      "U" -> %Point{x: location.x, y: location.y + length}
      "D" -> %Point{x: location.x, y: location.y - length}
      "R" -> %Point{x: location.x + length, y: location.y}
      "L" -> %Point{x: location.x - length, y: location.y}
    end
  end

  defp get_all_valid_intersections(path_1_lines, path_2_lines) do
    for(line_1 <- path_1_lines, line_2 <- path_2_lines, do: get_intersection(line_1, line_2))
    |> Enum.filter(fn point -> !is_nil(point) && point.x != 0 && point.y != 0 end)
  end

  defp get_intersection(line_1, line_2) do
    cond do
      lines_intersect?(line_1, line_2) ->
        %Point{x: line_2.start.x, y: line_1.start.y}

      lines_intersect?(line_2, line_1) ->
        %Point{x: line_1.start.x, y: line_2.start.y}

      true ->
        nil
    end
  end

  defp lines_intersect?(possibly_horizontal, possibly_vertical) do
    Enum.member?(
      possibly_horizontal.start.x..possibly_horizontal.end.x,
      possibly_vertical.start.x
    ) &&
      Enum.member?(
        possibly_vertical.start.y..possibly_vertical.end.y,
        possibly_horizontal.start.y
      )
  end

  defp distance_to_center(point) do
    abs(point.x) + abs(point.y)
  end

  defp get_summed_distances_to_intersections(intersections, path_1_lines, path_2_lines) do
    intersections
    |> Enum.map(fn intersection ->
      get_shortest_distance_to_intersection(intersection, path_1_lines, 0) +
        get_shortest_distance_to_intersection(intersection, path_2_lines, 0)
    end)
  end

  defp get_shortest_distance_to_intersection(
         intersection,
         [next_line | remaining_lines],
         distance_traveled
       ) do
    if includes_point?(next_line, intersection) do
      distance_traveled + distance_between_points(next_line.start, intersection)
    else
      get_shortest_distance_to_intersection(
        intersection,
        remaining_lines,
        distance_traveled + distance_between_points(next_line.start, next_line.end)
      )
    end
  end

  defp includes_point?(line, point) do
    (Enum.member?(line.start.x..line.end.x, point.x) && line.start.y == point.y) ||
      (Enum.member?(line.start.y..line.end.y, point.y) && line.start.x == point.x)
  end

  defp distance_between_points(point_1, point_2) do
    if point_1.x == point_2.x do
      abs(point_2.y - point_1.y)
    else
      abs(point_2.x - point_1.x)
    end
  end

  defp line_length(line) do
    if line.start.x == line.end.x do
      abs(line.end.y - line.start.y)
    else
      abs(line.end.x - line.start.x)
    end
  end
end

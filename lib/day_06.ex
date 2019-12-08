defmodule Day06 do
  defmodule Orbit do
    @enforce_keys [:center, :orbiter]
    defstruct [:center, :orbiter]
  end

  @center_of_mass "COM"

  def get_total_orbits(orbit_list_string) do
    direct_orbit_set = parse_direct_orbit_set(orbit_list_string)
    count_orbits(direct_orbit_set, @center_of_mass, 0)
  end

  def get_orbital_transfer_count(start, destination, orbit_list_string) do
    direct_orbit_set = parse_direct_orbit_set(orbit_list_string)

    start_path_to_com =
      get_orbit_for_orbiter(start, direct_orbit_set)
      |> build_path_to_com(direct_orbit_set, [start])

    destination_path_to_com =
      get_orbit_for_orbiter(destination, direct_orbit_set)
      |> build_path_to_com(direct_orbit_set, [destination])

    common_path_index =
      get_highest_index_beyond_common_center(start_path_to_com, destination_path_to_com)

    length(start_path_to_com) - 1 - common_path_index +
      length(destination_path_to_com) - 1 - common_path_index
  end

  defp parse_direct_orbit_set(orbit_list_string) do
    orbit_list_string
    |> String.split("\n")
    |> Enum.filter(fn string -> String.length(string) != 0 end)
    |> Enum.map(&to_orbit/1)
    |> MapSet.new()
  end

  defp to_orbit(relationship_string) do
    [center | [oribter | _]] = relationship_string |> String.split(")")
    %Orbit{center: center, orbiter: oribter}
  end

  defp count_orbits(orbit_set, from_center, distance_from_com) do
    new_distance = distance_from_com + 1

    related_orbit_set =
      orbit_set
      |> Enum.filter(fn orbit -> orbit.center == from_center end)
      |> MapSet.new()

    remaining_orbit_set = MapSet.difference(orbit_set, related_orbit_set)

    related_orbit_count = MapSet.size(related_orbit_set) * new_distance

    distant_orbit_count =
      related_orbit_set
      |> Enum.map(fn orbit ->
        count_orbits(remaining_orbit_set, orbit.orbiter, new_distance)
      end)
      |> Enum.sum()

    related_orbit_count + distant_orbit_count
  end

  defp get_orbit_for_orbiter(orbiter_key, orbit_set) do
    Enum.find(orbit_set, fn orbit -> orbit.orbiter == orbiter_key end)
  end

  defp build_path_to_com(orbit, orbit_set, path) do
    next_orbit = get_orbit_for_orbiter(orbit.center, orbit_set)

    if next_orbit.center == @center_of_mass do
      [next_orbit.center, next_orbit.orbiter] ++ path
    else
      build_path_to_com(next_orbit, orbit_set, [next_orbit.orbiter | path])
    end
  end

  defp get_highest_index_beyond_common_center(path_1, path_2) do
    highest_common_center =
      Enum.zip([path_1, path_2])
      |> Enum.reduce_while(@center_of_mass, fn pair, last_match ->
        if elem(pair, 0) == elem(pair, 1), do: {:cont, elem(pair, 0)}, else: {:halt, last_match}
      end)

    Enum.find_index(path_1, fn center -> highest_common_center == center end) + 1
  end
end

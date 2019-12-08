defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  describe "get total orbits" do
    test "gets one orbit" do
      assert Day06.get_total_orbits("COM)A") == 1
    end

    test "sums direct and indirect orbits" do
      assert Day06.get_total_orbits("COM)A\nA)B\n") == 3
    end

    test "handles branching in the orbit tree" do
      assert Day06.get_total_orbits("COM)A\nA)B\nA)C\n") == 5
    end

    test "gets the right count for the example" do
      input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L"

      assert Day06.get_total_orbits(input) == 42
    end

    test "gets the right answer" do
      input = File.read!("test/input/day_06_input.txt")

      assert Day06.get_total_orbits(input) |> IO.inspect(label: "PART 1 ANSWER") > 0
    end
  end

  describe "get orbital transfer count" do
    test "gets zero transfers when already orbiting same center" do
      assert Day06.get_orbital_transfer_count("B", "C", "COM)A\nA)B\nA)C\n") == 0
    end

    test "gets multiple transfers" do
      assert Day06.get_orbital_transfer_count("D", "E", "COM)A\nA)B\nA)C\nB)D\nC)E") == 2
    end

    test "gets the right count for the example" do
      input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nDx)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN"

      assert Day06.get_orbital_transfer_count("YOU", "SAN", input) == 4
    end

    test "gets the right answer" do
      input = File.read!("test/input/day_06_input.txt")

      assert Day06.get_orbital_transfer_count("YOU", "SAN", input)
             |> IO.inspect(label: "PART 2 ANSWER") > 0
    end
  end
end

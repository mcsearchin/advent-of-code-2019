defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  alias Day10.Location

  describe "get max asteroid view counts" do
    test "example 1" do
      input = """
      .#..#
      .....
      #####
      ....#
      ...##
      """

      assert Day10.get_max_asteroid_view_count(input) == 8
    end

    test "example 2" do
      input = """
      ......#.#.
      #..#.#....
      ..#######.
      .#.#.###..
      .#..#.....
      ..#....#.#
      #..#....#.
      .##.#..###
      ##...#..#.
      .#....####
      """

      assert Day10.get_max_asteroid_view_count(input) == 33
    end

    test "example 5" do
      input = """
      .#..##.###...#######
      ##.############..##.
      .#.######.########.#
      .###.#######.####.#.
      #####.##.#.##.###.##
      ..#####..#.#########
      ####################
      #.####....###.#.#.##
      ##.#################
      #####.##.###..####..
      ..######..##.#######
      ####.##.####...##..#
      .#####..#.######.###
      ##...#.##########...
      #.##########.#######
      .####.#.###.###.#.##
      ....##.##.###..#####
      .#.#.###########.###
      #.#.#.#####.####.###
      ###.##.####.##.#..##
      """

      assert Day10.get_max_asteroid_view_count(input) == 210
    end

    test "finds answer" do
      input = """
      #..#....#...#.#..#.......##.#.####
      #......#..#.#..####.....#..#...##.
      .##.......#..#.#....#.#..#.#....#.
      ###..#.....###.#....##.....#...#..
      ...#.##..#.###.......#....#....###
      .####...##...........##..#..#.##..
      ..#...#.#.#.###....#.#...##.....#.
      ......#.....#..#...##.#..##.#..###
      ...###.#....#..##.#.#.#....#...###
      ..#.###.####..###.#.##..#.##.###..
      ...##...#.#..##.#............##.##
      ....#.##.##.##..#......##.........
      .#..#.#..#.##......##...#.#.#...##
      .##.....#.#.##...#.#.#...#..###...
      #.#.#..##......#...#...#.......#..
      #.......#..#####.###.#..#..#.#.#..
      .#......##......##...#..#..#..###.
      #.#...#..#....##.#....#.##.#....#.
      ....#..#....##..#...##..#..#.#.##.
      #.#.#.#.##.#.#..###.......#....###
      ...#.#..##....###.####.#..#.#..#..
      #....##..#...##.#.#.........##.#..
      .#....#.#...#.#.........#..#......
      ...#..###...#...#.#.#...#.#..##.##
      .####.##.#..#.#.#.#...#.##......#.
      .##....##..#.#.#.......#.....####.
      #.##.##....#...#..#.#..###..#.###.
      ...###.#..#.....#.#.#.#....#....#.
      ......#...#.........##....#....##.
      .....#.....#..#.##.#.###.#..##....
      .#.....#.#.....#####.....##..#....
      .####.##...#.......####..#....##..
      .#.#.......#......#.##..##.#.#..##
      ......##.....##...##.##...##......
      """

      assert Day10.get_max_asteroid_view_count(input) |> IO.inspect(label: "PART 1 ANSWER") > 0
    end
  end

  describe "blocks?" do
    test "blocks when both have zero on the same axis with the same sign" do
      assert Day10.blocks?(%Location{x: 0, y: 2}, %Location{x: 0, y: 1}) == true
      assert Day10.blocks?(%Location{x: 0, y: -2}, %Location{x: 0, y: -1}) == true
      assert Day10.blocks?(%Location{x: 2, y: 0}, %Location{x: 1, y: 0}) == true
      assert Day10.blocks?(%Location{x: -2, y: 0}, %Location{x: -1, y: 0}) == true
    end

    test "does not block when both have zero on the same axis with different signs" do
      assert Day10.blocks?(%Location{x: 0, y: -1}, %Location{x: 0, y: 1}) == false
      assert Day10.blocks?(%Location{x: 0, y: 1}, %Location{x: 0, y: -1}) == false
      assert Day10.blocks?(%Location{x: -1, y: 0}, %Location{x: 1, y: 0}) == false
      assert Day10.blocks?(%Location{x: 1, y: 0}, %Location{x: -1, y: 0}) == false
    end

    test "does not block when both have zero on the same axis but blocker is behind location" do
      assert Day10.blocks?(%Location{x: 0, y: 1}, %Location{x: 0, y: 2}) == false
      assert Day10.blocks?(%Location{x: 0, y: -1}, %Location{x: 0, y: -2}) == false
      assert Day10.blocks?(%Location{x: 1, y: 0}, %Location{x: 2, y: 0}) == false
      assert Day10.blocks?(%Location{x: -1, y: 0}, %Location{x: -2, y: 0}) == false
    end

    test "blocks when both have same ratio from 0,0 and blocker is closer" do
      assert Day10.blocks?(%Location{x: 2, y: 2}, %Location{x: 1, y: 1}) == true
      assert Day10.blocks?(%Location{x: -2, y: 4}, %Location{x: -1, y: 2}) == true
      assert Day10.blocks?(%Location{x: -9, y: -6}, %Location{x: -3, y: -2}) == true
      assert Day10.blocks?(%Location{x: 4, y: -4}, %Location{x: 2, y: -2}) == true
    end

    test "does not blocks whe both have same ratio from 0,0 and blocker has differnt signs" do
      assert Day10.blocks?(%Location{x: 2, y: 2}, %Location{x: -1, y: 1}) == false
      assert Day10.blocks?(%Location{x: -2, y: 4}, %Location{x: 1, y: -2}) == false
      assert Day10.blocks?(%Location{x: -9, y: -6}, %Location{x: -3, y: 2}) == false
      assert Day10.blocks?(%Location{x: 4, y: -4}, %Location{x: -2, y: 2}) == false
    end
  end
end

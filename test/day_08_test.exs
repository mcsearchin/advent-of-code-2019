defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  describe "get layer counts" do
    test "counts a single character for a single layer" do
      assert Day08.get_layer_counts("111111", 2, 3) == [%{"1" => 6}]
    end

    test "counts multiple characters for a single layer" do
      assert Day08.get_layer_counts("120121", 2, 3) == [%{"0" => 1, "1" => 3, "2" => 2}]
    end

    test "counts characters for multiple layers" do
      assert Day08.get_layer_counts("111122201210", 2, 2) == [
               %{"1" => 4},
               %{"2" => 3, "0" => 1},
               %{"0" => 1, "1" => 2, "2" => 1}
             ]
    end

    test "finds answer" do
      input = File.read!("test/input/day_08_input.txt")

      layer =
        Day08.get_layer_counts(input, 25, 6)
        |> Enum.sort(&(Map.get(&1, "0", 0) < Map.get(&2, "0", 0)))
        |> List.first()

      answer = layer["1"] * layer["2"]

      IO.inspect(answer, label: "PART 1 ANSWER")
      assert answer > 0
    end
  end

  describe "decode message" do
    test "decodes single layer" do
      assert Day08.decode_image("1001", 2, 2) == " *\n* "
    end

    test "ignores second layer if first is opaque single layer" do
      assert Day08.decode_image("01101001", 2, 2) == "* \n *"
    end

    test "decodes multiple layers with transparent pixels" do
      assert Day08.decode_image("0222112222120000", 2, 2) == "* \n *"
    end

    test "finds answer" do
      input = File.read!("test/input/day_08_input.txt")

      decoded = Day08.decode_image(input, 25, 6)
      IO.puts("PART 2 ANSWER")
      IO.puts(decoded)
      assert String.length(decoded) > 0
    end
  end
end

defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  describe "get possible password count" do
    test "finds 1 when range contains ascending numbers with repeating digits" do
      assert Day04.get_possible_password_count(123_499..123_499) == 1
    end

    test "finds 0 when no numbers are ascending" do
      assert Day04.get_possible_password_count(133_234..133_299) == 0
    end

    test "finds 0 when no numbers are descending with a 0" do
      assert Day04.get_possible_password_count(223_450..223_450) == 0
    end

    test "finds 0 when no numbers are repeating" do
      assert Day04.get_possible_password_count(123_456..123_459) == 0
    end

    test "find answer" do
      answer =
        Day04.get_possible_password_count(138_307..654_504)
        |> IO.inspect(label: "PART 1 ANSWER")

      assert answer > 0
    end
  end

  describe "get more specific possible password count" do
    test "finds 1 when range contains ascending numbers with repeating digits" do
      assert Day04.get_more_specific_possible_password_count(123_499..123_500) == 1
    end

    test "finds 0 when no numbers are ascending" do
      assert Day04.get_more_specific_possible_password_count(133_234..133_299) == 0
    end

    test "finds 0 when no numbers are repeating" do
      assert Day04.get_more_specific_possible_password_count(123_456..123_459) == 0
    end

    test "finds 0 when more than two numbers are repeating" do
      assert Day04.get_more_specific_possible_password_count(122_234..122_243) == 0
    end

    test "finds 2 when each number in range contains at least one set of exactly two numbers repeating" do
      assert Day04.get_more_specific_possible_password_count(122_333..122_334) == 2
    end

    test "finds 1 when two repeating numbers occur after 3 repeating numbers" do
      assert Day04.get_more_specific_possible_password_count(111_233..111_234) == 1
    end

    test "finds correct number for less trivial example" do
      assert Day04.get_more_specific_possible_password_count(123_334..123_460) == 27
    end

    test "find answer" do
      answer =
        Day04.get_more_specific_possible_password_count(138_307..654_504)
        |> IO.inspect(label: "PART 2 ANSWER")

      assert answer > 0
    end
  end
end

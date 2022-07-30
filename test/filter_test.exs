defmodule FilterTest do
  use ExUnit.Case
  doctest Filter

  test "empty values" do
    ["eq", "cont", "start"]
    |> Enum.each(fn matcher ->
      assert Filter.matches?(%{"name" => "John Doe"}, %{"name__#{matcher}" => nil}) == false
    end)
  end

  test "raises if matcher is not handled" do
    assert_raise FunctionClauseError, fn ->
      Filter.matches?(%{"name" => "John Doe"}, %{"name__" => ""})
    end

    assert_raise FunctionClauseError, fn ->
      Filter.matches?(%{"name" => "John Doe"}, %{"name__mistyped" => ""})
    end
  end

  test "[eq] equals - case insensitive" do
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__eq" => "John Doe"}) == true
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__eq" => "john doe"}) == true

    assert Filter.matches?(%{"name" => "John Doe", "email" => "john@doe.com"}, %{
             "name__eq" => "John Doe",
             "email__eq" => "john@doe.com"
           }) == true

    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__eq" => "John Do"}) == false

    assert Filter.matches?(%{"name" => "John Doe", "email" => "john@doe.com"}, %{
             "name__eq" => "John Doe",
             "email__eq" => "john@doe.comm"
           }) == false
  end

  test "[cont] contains - case insensitive" do
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__cont" => "J"}) == true
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__cont" => "john "}) == true
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__cont" => "John doE"}) == true

    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__cont" => "John Doer"}) == false
  end

  test "[start] starts with - case insensitive" do
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__start" => "j"}) == true
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__start" => "john "}) == true
    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__start" => "John doE"}) == true

    assert Filter.matches?(%{"name" => "John Doe"}, %{"name__start" => "John Doer"}) == false
  end
end

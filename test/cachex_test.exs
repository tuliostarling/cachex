defmodule CachexTest do
  use ExUnit.Case

  test "return :not_found when key don't exist" do
    assert Cachex.get(fake_key()) == {:error, :not_found}
  end

  test "return :expired when ttl is expired" do
    key_name = fake_key()
    Cachex.insert(key_name, :some_value, -1)
    assert Cachex.get(key_name) == {:error, :expired}
  end

  test "return :duplicate when key already exists" do
    key_name = fake_key()
    Cachex.insert(key_name, :some_value)
    assert Cachex.insert(key_name, :some_value) == {:error, :duplicate}
  end

  test "return key when it exists and ttl is valid" do
    key_name = fake_key()
    Cachex.insert(key_name, :some_value)
    {:ok, value, _expires} = Cachex.get(key_name)
    assert value == :some_value
  end

  defp fake_key, do: Faker.String.naughty() |> String.to_atom()
end

defmodule Cachex.Worker do
  @moduledoc false

  @table Cachex

  def insert(key, value, ttl) do
    expires = now() + ttl

    case :ets.insert_new(@table, {key, {value, expires}}) do
      false -> {:error, :duplicate}
      true -> {:ok, {key, {value, expires}}}
    end
  end

  def get(key) do
    with [{^key, {value, expires}}] <- :ets.lookup(@table, key),
         true <- expires >= now() do
      {:ok, value, now() - expires}
    else
      [] ->
        {:error, :not_found}

      false ->
        delete(key)
        {:error, :expired}
    end
  end

  def delete(key), do: :ets.delete(@table, key)

  defp now(), do: :erlang.system_time(:second)
end

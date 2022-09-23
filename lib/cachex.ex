defmodule Cachex do
  @moduledoc """
  Simple cache application made with GenServer and ETS
  """

  use GenServer

  require Logger

  @default_ttl 300

  def child_spec(_opts \\ []), do: %{id: __MODULE__, start: {__MODULE__, :start_link, []}}

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @impl true
  def init(_) do
    :ets.new(__MODULE__, [:ordered_set, :public, :named_table, {:write_concurrency, true}])
    {:ok, nil}
  rescue
    ArgumentError -> {:stop, :already_started}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.warn("Cachex received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  @spec insert(term(), term(), term()) :: {:ok, {term(), {term(), term()}}} | {:error, :duplicate}
  defdelegate insert(key, value, ttl \\ @default_ttl), to: Cachex.Worker

  @spec get(term()) :: {:ok, term(), term()} | {:error, :expired} | {:error, :not_found}
  defdelegate get(key), to: Cachex.Worker

  @spec delete(term()) :: boolean()
  defdelegate delete(key), to: Cachex.Worker
end

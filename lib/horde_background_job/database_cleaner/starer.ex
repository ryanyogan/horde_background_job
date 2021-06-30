defmodule HordeBackgroundJob.DatabaseCleaner.Starter do
  require Logger

  alias HordeBackgroundJob.{DatabaseCleaner, HordeSupervisor, HordeRegistry}

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :temporary,
      shutdown: 500
    }
  end

  def start_link(opts) do
    name =
      opts
      |> Keyword.get(:name, DatabaseCleaner)
      |> via_tuple()

    new_opts = Keyword.put(opts, :name, name)

    child_spec = %{
      id: DatabaseCleaner,
      start: {DatabaseCleaner, :start_link, [new_opts]}
    }

    HordeSupervisor.start_child(child_spec)

    :ignore
  end

  def whereis(name \\ DatabaseCleaner) do
    name
    |> via_tuple()
    |> GenServer.whereis()
  end

  defp via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end
end

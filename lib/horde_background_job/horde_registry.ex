defmodule HordeBackgroundJob.HordeRegistry do
  use Horde.Registry

  def start_link(_) do
    Horde.Registry.start_link(__MODULE__, [keys: :unique], name: __MODULE__)
  end

  @impl true
  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.Registry.init()
  end

  defp members do
    Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
  end
end

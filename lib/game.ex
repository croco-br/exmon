defmodule Exmon.Game do
  alias Exmon.Player
  use Agent

  def start(cpu, player) do
    initial_value = %{cpu: cpu, player: player, turn: :player, status: :started}
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def info do
    Agent.get(__MODULE__, & &1)
  end

  def update(state) do
    Agent.update(__MODULE__, fn _ -> update_game_status(state) end)
  end

  def player, do: Map.get(info(), :player)
  def turn, do: Map.get(info(), :turn)
  def fetch_player(player), do: Map.get(info(), player)

  defp update_game_status(
         %{player: %Player{life: player_life}, cpu: %Player{life: cpu_life}} = state
       )
       when player_life == 0 or cpu_life == 0,
       do: Map.put(state, :status, :game_over)

  defp update_game_status(state) do
    state
    |> Map.put(:status, :continue)
    |> update_turn()
  end

  defp update_turn(%{turn: :cpu} = state), do: Map.put(state, :turn, :player)
  defp update_turn(%{turn: :player} = state), do: Map.put(state, :turn, :cpu)
end

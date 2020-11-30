defmodule Exmon.Game.Actions do
  alias Exmon.Game
  alias Exmon.Game.Actions.{Attack, Heal}

  def fetch_move(move) do
    Game.player()
    |> Map.get(:moves)
    |> find_move(move)
  end

  defp find_move(moves, move) do
    Enum.find_value(moves, {:error, move}, fn {key, value} ->
      if value == move, do: {:ok, key}
    end)
  end

  def attack(move) do
    case Game.turn() do
      :player -> Attack.attack_opponent(:cpu, move)
      :cpu -> Attack.attack_opponent(:player, move)
    end
  end

  def heal() do
    case Game.turn() do
      :player -> Heal.heal_life(:player)
      :cpu -> Heal.heal_life(:cpu)
    end
  end
end

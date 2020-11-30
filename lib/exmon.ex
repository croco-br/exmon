defmodule Exmon do
  alias Exmon.{Game, Player}
  alias Exmon.Game.{Actions, Status}
  @cpu_name "CPU"
  @cpu_moves [:move_avg, :move_rnd, :move_heal]

  def create_player(name, move_rnd, move_avg, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @cpu_name
    |> create_player(:punch, :kick, :cure)
    |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)
  end



  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> do_move()

    cpu_move(Game.info())
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)

  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp cpu_move(%{turn: :cpu, status: :continue}) do
    move = {:ok, Enum.random(@cpu_moves)}
    do_move(move)
  end

  defp cpu_move(_), do: :ok
end

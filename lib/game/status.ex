defmodule Exmon.Game.Status do
  @separator "======"

  def print_round_message(%{status: :started} = info) do
    IO.puts("\n #{@separator} The game has started! #{@separator} \n")
    IO.inspect(info)
    IO.puts("----------------------------------")
  end

  def print_round_message(%{status: :continue, turn: player} = info) do
    IO.puts("\n #{@separator} It's #{player} turn. #{@separator} \n")
    IO.inspect(info)
    IO.puts("----------------------------------")
  end

  def print_round_message(%{status: :game_over} = info) do
    IO.puts("\n #{@separator} The game is over. #{@separator} \n")
    IO.inspect(info)
    IO.puts("----------------------------------")
  end

  def print_wrong_move_message(move),
    do: IO.puts("\n #{@separator} Invalid move: #{move}. #{@separator}\n")

  def print_move_message(:cpu, :attack, damage),
    do: IO.puts("\n #{@separator} The CPU took #{damage} damage from Player. #{@separator}\n")

  def print_move_message(:player, :attack, damage),
    do: IO.puts("\n #{@separator} The Player took #{damage} damage from CPU. #{@separator}\n")

  def print_move_message(player, :heal, life),
    do: IO.puts("\n #{@separator} The #{player} healed itself to #{life} points. #{@separator}\n")
end

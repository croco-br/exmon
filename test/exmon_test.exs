defmodule Exmon.ExmonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Exmon.Player

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :kick, move_heal: :cure, move_rnd: :punch},
        name: "Teste"
      }

      assert expected_response == Exmon.create_player("Teste", :punch, :kick, :cure)
    end
  end

  describe "start_game/1" do
    test "returns a message when game starts" do
      player = Player.build("Teste", :punch, :kick, :cure)

      expected_message =
        capture_io(fn ->
          assert Exmon.start_game(player) == :ok
        end)

      assert expected_message =~ "The game has started"
      assert expected_message =~ "status: :started"
      assert expected_message =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Teste", :punch, :kick, :cure)

      capture_io(fn ->
        Exmon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, do the move and the cpu makes a move " do
      expected_message =
        capture_io(fn ->
          Exmon.make_move(:kick)
        end)

      assert expected_message =~ "The CPU took"
      assert expected_message =~ "It's cpu turn"
      assert expected_message =~ "It's player turn"
      assert expected_message =~ "status: :continue"
    end

    test "when the move is invalid, returns an error message" do
      expected_message =
        capture_io(fn ->
          Exmon.make_move(:xpto)
        end)

      assert expected_message =~ "Invalid move: xpto"
    end
  end
end

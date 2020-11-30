defmodule Exmon.GameTest do
  use ExUnit.Case
  alias Exmon.{Game, Player}

  describe "start/2" do
    test "Starts the game state" do
      player = Player.build("Adriano", :chute, :soco, :cura)
      cpu = Player.build("Enemy", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(cpu, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Adriano", :chute, :soco, :cura)
      cpu = Player.build("Enemy", :chute, :soco, :cura)
      Game.start(cpu, player)

      expected_response = %{
        cpu: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Enemy"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Adriano"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Adriano", :chute, :soco, :cura)
      cpu = Player.build("Enemy", :chute, :soco, :cura)
      Game.start(cpu, player)

      expected_response = %{
        cpu: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Enemy"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Adriano"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()

      new_state = %{
        cpu: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Enemy"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Adriano"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{new_state | turn: :cpu, status: :continue}

      assert expected_response == Game.info()
    end
  end

  describe "turn/0" do
    test "returns the turn" do
      player = Player.build("Adriano", :chute, :soco, :cura)
      cpu = Player.build("Enemy", :chute, :soco, :cura)
      Game.start(cpu, player)

      expected_turn = Game.turn()
      assert expected_turn == :player
    end
  end

  describe "player/0" do
    test "returns the player" do
      player = Player.build("Adriano", :chute, :soco, :cura)
      cpu = Player.build("Enemy", :chute, :soco, :cura)
      Game.start(cpu, player)

      assert Game.player() == player
    end
  end
end

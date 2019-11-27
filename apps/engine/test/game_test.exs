defmodule GameTest do
  alias Engine.Game
  use ExUnit.Case
  doctest Engine.Game

  setup do
    game = Game.new_game()

    %{game: game}
  end

  test "new game creation", state do
    assert state.game.phase == :initializing
    assert state.game.board == []
  end

  test "add players", state do
    {:ok, _, game} = Game.add_player(state.game, "p1")
    assert map_size(game.players) == 1
    assert game.players[0].name == "p1"

    {:ok, _, game} = Game.add_player(game, "p2")
    assert map_size(game.players) == 2
    assert game.players[1].name == "p2"

    {:ok, _, game} = Game.add_player(game, "p3")
    {:ok, _, game} = Game.add_player(game, "p4")
    {:ok, _, game} = Game.add_player(game, "p5")
    assert map_size(game.players) == 5
  end

  test "can't start game with one player", state do
    {:ok, _, game} = Game.add_player(state.game, "p1")
    assert {:error, :not_enough_players} = Game.start_game(game)
  end
end

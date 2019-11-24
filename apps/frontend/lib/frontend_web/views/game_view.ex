defmodule FrontendWeb.GameView do
  use FrontendWeb, :view

  def game_admin?(game, player_id) do
    player_id == game.players |> Map.keys() |> Enum.sort() |> List.first()
  end

  def current_player?(game, player_id) do
    game.player_turn == player_id
  end

  def get_current_player(game) do
    game.players[game.player_turn]
  end

  def cards_to_repr(cards) do
    cards |> Enum.map(&Engine.Card.to_repr/1) |> Enum.join(" ")
  end

  def log(game) do
    game.log
    # |> Enum.reverse()
    |> Enum.join("\n")
  end

  def minimum_bet(game) do
    case game.bet do
      0 -> game.big_blind
      x -> x + 1
    end
  end
end

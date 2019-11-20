defmodule FrontendWeb.GameView do
  use FrontendWeb, :view

  def game_admin?(game, player_id) do
    player_id == game.players |> Map.keys() |> Enum.sort() |> List.first()
  end
end

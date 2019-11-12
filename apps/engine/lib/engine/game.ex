defmodule Engine.Game do
  alias __MODULE__
  alias Engine.{Deck, Player}

  defstruct players: [
              %Player{name: "jan"},
              %Player{name: "sam"},
              %Player{name: "lol"}
            ],
            player_turn: 0,
            status: :initializing,
            small_blind: nil,
            big_blind: nil,
            pot: 0,
            deck: nil

  def new_game() do
    %Game{small_blind: 5, big_blind: 10, deck: Deck.start_link()}
  end

  def start_game(game = %{status: :initializing}) do
    case Engine.Steps.StartTurn.call(game) do
      {:ok, game} -> game
      {:error, error} -> {:error, error}
    end
  end
end

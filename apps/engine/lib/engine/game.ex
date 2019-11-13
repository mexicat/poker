defmodule Engine.Game do
  alias __MODULE__
  alias Engine.{Deck, Player}

  defstruct turn: 1,
            players: %{},
            player_turn: 0,
            status: :initializing,
            dealer: 0,
            small_blind: nil,
            big_blind: nil,
            pot: 0,
            deck: nil

  def new_game() do
    %Game{small_blind: 5, big_blind: 10, deck: Deck.start_link()}
  end

  def add_player(game = %{status: :initializing, players: players}, name) do
    id = Enum.count(players)
    new_player = %Player{name: name}
    {:ok, %{game | players: Map.put(players, id, new_player)}}
  end

  def add_player(_, _) do
    {:error, :cannot_add_players_after_game_start}
  end

  def check(game = %{player_turn: id}, _player = id) do
    Engine.Steps.Check.call(game)
  end

  def check(_, _) do
    {:error, :not_your_turn}
  end

  def start_game(%{status: :initializing, players: players}) when map_size(players) < 3 do
    {:error, :not_enough_players}
  end

  def start_game(game = %{status: :initializing}) do
    Engine.Steps.StartTurn.call(game)
  end
end

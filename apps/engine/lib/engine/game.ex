defmodule Engine.Game do
  alias __MODULE__
  alias Engine.{GameUtils, Player, Steps}

  defstruct turn: 1,
            players: %{},
            player_turn: 0,
            phase: :initializing,
            dealer: 0,
            small_blind: nil,
            big_blind: nil,
            pot: 0,
            bet: 0,
            winners: [],
            board: [],
            deck: nil,
            log: nil

  def new_game(deck, log \\ nil) do
    %Game{
      small_blind: 5,
      big_blind: 10,
      bet: 15,
      deck: deck,
      log: log
    }
  end

  def add_player(game = %Game{phase: :initializing, players: players}, name) do
    id = Enum.count(players)
    new_player = %Player{name: name}

    game =
      %{game | players: Map.put(players, id, new_player)}
      |> GameUtils.log("#{name} joined the game")

    {:ok, id, game}
  end

  def add_player(%Game{}, _) do
    {:error, :cannot_add_players_after_game_start}
  end

  def start_game(%{phase: :initializing, players: players}) when map_size(players) < 3 do
    {:error, :not_enough_players}
  end

  def start_game(game = %{phase: :initializing}) do
    Steps.StartTurn.call(game)
  end

  def check(game = %Game{player_turn: id}, _player = id) do
    Steps.Check.call(game)
  end

  def check(%Game{}, _) do
    {:error, :not_your_turn}
  end

  def bet(game = %Game{player_turn: id}, _player = id, bet) do
    Steps.Bet.call({game, bet})
  end

  def bet(%Game{}, _) do
    {:error, :not_your_turn}
  end

  def call_bet(game = %Game{player_turn: id}, _player = id) do
    Steps.CallBet.call(game)
  end

  def call_bet(%Game{}, _) do
    {:error, :not_your_turn}
  end

  def fold(game = %Game{player_turn: id}, _player = id) do
    Steps.Fold.call(game)
  end

  def fold(%Game{}, _) do
    {:error, :not_your_turn}
  end
end

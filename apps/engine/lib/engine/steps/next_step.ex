defmodule Engine.Steps.NextStep do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  step :set_next_player, unless: &(!one_player_remaining?(&1) && phase_complete?(&1))
  link Steps.NextPhase, if: &(!one_player_remaining?(&1) && phase_complete?(&1))
  step :set_winner, if: &one_player_remaining?(&1)

  skip :cleanup_stuff, if: &(&1.phase != :finished)
  step :distribute_coins
  step :reset_board, with: &Map.put(&1, :board, [])
  step :cleanup_dead
  step :reset_players, with: &reset_players/1
  step :finish_game, if: &(map_size(&1.players) == 1)
  link Steps.StartTurn, if: &(map_size(&1.players) > 1)

  def set_next_player(game = %Game{player_turn: player, players: players}) do
    %{game | player_turn: next_player(player, players)}
  end

  def set_winner(game = %Game{}) do
    IO.puts(" SET WINNER ")
    winners = for {k, _} <- remaining_players(game), do: k
    %{game | winners: winners, phase: :finished}
  end

  def distribute_coins(game = %Game{winners: winners, players: players, pot: pot}) do
    {each, remainder} = calculate_coins(pot, length(winners))

    players =
      players
      |> Enum.map(fn {k, player} ->
        if Enum.member?(winners, k) do
          {k, %{player | coins: player.coins + each}}
        else
          {k, player}
        end
      end)
      |> Enum.into(%{})

    %{game | players: players, pot: remainder, winners: []}
  end

  def cleanup_dead(game = %Game{players: players}) do
    players =
      players
      |> Enum.reject(fn {_k, player} -> player.coins <= 0 end)
      |> Enum.into(%{})

    %{game | players: players}
  end

  defp calculate_coins(total, n_of_players) do
    each = div(total, n_of_players)
    remainder = rem(total, n_of_players)
    {each, remainder}
  end
end

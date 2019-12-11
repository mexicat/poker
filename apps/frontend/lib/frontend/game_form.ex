defmodule Frontend.GameForm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Frontend.GameForm

  embedded_schema do
    field(:player_coins, :integer)
    field(:player_name, :string)
    field(:small_blind, :integer)
  end

  def changeset(game_form, attrs \\ %{}) do
    cast(game_form, attrs, [:player_name, :small_blind, :player_coins])
  end

  def new_game(%GameForm{} = game_form, attrs) do
    game_form
    |> changeset(attrs)
    |> cast(attrs, [:player_name, :small_blind, :player_coins])
    |> validate_required([:player_name, :small_blind, :player_coins])
    |> validate_length(:player_name, max: 50)
    |> validate_number(:small_blind, greater_than_or_equal_to: 5, less_than: 10000)
    |> validate_number(:player_coins, greater_than_or_equal_to: 20, less_than: 10000)
    |> validate_blind_and_coins(:small_blind, :player_coins)
    |> apply_action(:insert)
  end

  def validate_blind_and_coins(changeset, small_blind, player_coins) do
    {_, sb_value} = fetch_field(changeset, small_blind)
    {_, pc_value} = fetch_field(changeset, player_coins)

    if sb_value * 4 > pc_value do
      add_error(changeset, player_coins, "coins must be at least 4x the small blind")
    else
      changeset
    end
  end
end

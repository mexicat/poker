defmodule Engine.GameUtils do
  def next_position(position, players_count)
  def next_position(same, same), do: 0
  def next_position(position, _players_count), do: position + 1
end

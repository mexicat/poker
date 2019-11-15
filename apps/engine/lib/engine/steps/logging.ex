defmodule Engine.Steps.Logging do
  def instrument(:stage_completed, pipeline, input) do
    IO.puts("PHASE---")
    IO.inspect(:stage_completed)
    IO.puts("PIPELINE---")
    IO.inspect(pipeline)
    IO.puts("INPUT---")
    IO.inspect(input)
  end

  def instrument(_, _, _) do
  end
end

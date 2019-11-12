defmodule Engine.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [worker(Engine.Server, [])]

    opts = [
      name: Engine.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, opts)
  end
end

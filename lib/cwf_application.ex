defmodule CWF.Application do
  use Application

  @impl true
  def start(_type, _args) do 

    children = [
      {DynamicSupervisor, name: CWF.DynParser, strategy: :one_for_one},

      {CWF.Forecast, name: Forecast},

      %{
        id: EventGet,
        start: {CWF.Event, :start_link, ["http://localhost:4000/iot"]}
      },


    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

end

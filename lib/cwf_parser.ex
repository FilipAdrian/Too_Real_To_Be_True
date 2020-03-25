defmodule CWF.Parser do
    use GenServer

    def start_link(state) do
        GenServer.start_link(__MODULE__,%{}, state)
    end

    @impl true
    def init(data_list) do
        {:ok, data_list}
    end

    @impl true
    def handle_cast({:send, msg}, state) do
        json_msg = Jason.decode!(msg)
        IO.inspect json_msg , label: "<-- Json Format -->"
        {:noreply, state}
    end


end
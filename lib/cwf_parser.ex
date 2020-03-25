defmodule CWF.Parser do
    use GenServer

    def start_link(state) do
        GenServer.start_link(__MODULE__,%{}, state)
    end

    def init(data_list) do
        {:ok, data_list}
    end

end
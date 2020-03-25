defmodule CWF.Parser do
    use GenServer, restart: :transient

    def start_link(state) do
        GenServer.start_link(__MODULE__,%{}, state)
    end

    @impl true
    def init(data_list) do
        {:ok, data_list}
    end

    @impl true
    def handle_cast({:send, msg}, state) do
        var = is_panic?(msg)

        case var do
            true -> IO.inspect "<--- Panic Message Detected --->"
                    Process.exit(self(), :kill)
                    
            _ -> value = parse(msg)
                GenServer.cast(Forecast,{:process, value["message"]})
                # IO.inspect value , label: "<-- Json Format -->  "
        end

        {:noreply, state}
    end

    defp parse(msg) do
        Jason.decode!(msg)
    end


    defp is_panic?(msg) do
        panic? = String.split(msg, ":") 
                 |> (Enum.at 1) 
                    |> (String.trim )
                        |> (String.starts_with? "panic")
 
        panic?
    end

end
defmodule CWF.Aggregator do
    use GenServer

    def start_link(state) do
        GenServer.start_link(__MODULE__, [{:time, DateTime.utc_now()}, {:count, 0}, {:data, []} ], state)
    end

    @impl true
    def init(data_list) do
        {:ok, data_list}
    end

    @impl true
    def handle_call({:print, msg}, _from, state) do
        state = update_state(msg, state)
        current_time = DateTime.utc_now()

        state = if DateTime.diff(current_time, state[:time]) >= 5 do
            print_msg(msg)
            state = put_in state[:time] , current_time 
            else state end
        
        {:reply, :ok ,state}
    end

    defp update_state(msg, state) do
        state = update_in state[:count] , &(&1 + 1)
        state = put_in state[:data] , [ msg | state[:data] ]
        state
    end

    defp print_msg( msg ) do
        IO.puts("|.......................................|")
        IO.puts("|.........#StaiAcasa_COVID-19...........|")
        IO.puts("|.......................................|")
        IO.puts("----------------------------------------")
        IO.inspect(msg["wheather"], label: " Wheather Forecast ")
        IO.puts("----------------------------------------")
        IO.puts("              Metrics:")
        Enum.map msg, fn {k,v} -> cond do
                                     k == "wheather" -> "ok" 
                                     true -> IO.inspect(v, label: k) 
                                    end end
    end
end
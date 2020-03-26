defmodule CWF.Event do
    use GenServer

    @impl true
    def init(state) do
        IO.inspect state.url
        EventsourceEx.new(state.url, stream_to: self())
        IO.inspect "<--- Event Fetch URL Started --> "
        {:ok, state}
      end

    def start_link(url) do
        GenServer.start_link(__MODULE__, %{url: url})
    end

    @impl true
    def handle_info(msg, state) do

        send_msg_worker(msg)

        {:noreply, state}
    end

    defp send_msg_worker( msg ) do
        {:ok, pid} =  DynamicSupervisor.start_child(CWF.DynParser, CWF.Parser)
        GenServer.cast(pid,{:send, msg.data})
    end


end
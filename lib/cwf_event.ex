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
        # IO.inspect msg.data
        GenServer.cast(Parser,{:send, msg.data})
        {:noreply, state}
    end

end
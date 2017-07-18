defmodule DistributedElixir.Ping do
  @doc """
  Starts the process if there is no one running on the cluster.
  If there is another one running, just return an error
  """
  def start_link() do
    case :global.whereis_name(:ping) do
      pid when is_pid(pid) ->
        {:error, :already_started}
      _ ->
        pid = spawn_link(fn ->
          :global.register_name(:ping, self())
          loop()
        end)

        {:ok, pid}
    end
  end

  @doc """
  Make calls to the ping process and waits for response.
  If there is no response in 1 second, it returns an error
  If the applicastion is not running, returns an error.
  """
  def ping() do
    case :global.whereis_name(:ping) do
      pid when is_pid(pid) ->
        send(pid, {:ping, self()})

        receive do
          {:pong} -> {:ok, :pong}
        after
          1_000 ->  {:error, "Timeout!"}
        end
      _ ->
        {:error, "Application not started!"}
    end
  end

  # Function to execute on the process.
  # Just waits for pings and responds with pongs.
  defp loop() do
    receive do
      {:ping, pid} ->
        IO.puts("Received ping from #{inspect(pid)}")
        send(pid, {:pong})
    end

    loop()
  end
end

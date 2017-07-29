defmodule DistributedElixir.Calculator do
  use GenServer

  ## Client API

  @doc """
  Starts the calculator.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: {:global, :calculator})
  end

  @doc """
  Perform the sum of two operators, `op1` and `op2`

  Returns `{:ok, result}` if the operands can be used, `{:error}` otherwise.
  """
  def sum(op1, op2) do
    GenServer.call({:global, :calculator}, {:sum, {op1, op2}})
  end

  @doc """
  Perform the multiplication of two operators, `op1` and `op2`

  Returns `{:ok, result}` if the operands can be used, `{:error}` otherwise.
  """
  def multiply(op1, op2) do
    GenServer.call({:global, :calculator}, {:multiply, {op1, op2}})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:sum, {op1, op2}}, _from, state) when is_number(op1) and is_number(op2) do
    {:reply, {:ok, op1+op2}, state}
  end
  def handle_call({:sum, {_, _}}, _from, state) do
    {:reply, {:error}, state}
  end

  def handle_call({:multiply, {op1, op2}}, _from, state) when is_number(op1) and is_number(op2) do
    {:reply, {:ok, op1*op2}, state}
  end
  def handle_call({:multiply, {_, _}}, _from, state) do
    {:reply, {:error}, state}
  end
end

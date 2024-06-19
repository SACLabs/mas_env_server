defmodule MasEnvServer.ReportDb do
  use GenServer

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:create, task_id}, state) do
    new_state = Map.put(state, task_id, %{})
    {:noreply, new_state}
  end

  def handle_cast({:write_report, {task_id, report}}, state) do
    report_length = state |> Map.get(task_id) |> Kernel.map_size()
    update_map = state |> Map.get(task_id) |> Map.put(to_string(report_length + 1), report)
    new_state = Map.put(state, task_id, update_map)
    {:noreply, new_state}
  end

  def handle_call({:retrieve, task_id}, _from, state) do
    {:reply, Map.get(state, task_id), state}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :report_db)
  end

  # ------- user api ------
  def create_report(task_id) do
    GenServer.cast(:report_db, {:create, task_id})
  end

  def write_report(task_id, report) do
    GenServer.cast(:report_db, {:write_report, {task_id, report}})
  end

  def retrieve_report(task_id) do
    GenServer.call(:report_db, {:retrieve, task_id})
  end
end

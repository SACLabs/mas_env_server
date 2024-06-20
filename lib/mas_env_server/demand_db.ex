defmodule MasEnvServer.DemandDb do
  use GenServer

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:create, {uuid, readme_content, test_map}}, state) do
    # TODO,增加检测，这个函数只做新的demand的增加操作
    new_state =
      Map.put(state, uuid, %{
        "README" => readme_content,
        "report" => %{},
        "source_code" => %{"tree" => "", "content" => test_map}
      })

    {:noreply, new_state}
  end

  def handle_cast({:update, {uuid, report, source_code}}, state) do
    # TODO，后续是否需要对给定的demand进行更新
    task_map =
      Map.get(state, uuid) |> Map.put("report", report) |> Map.put("source_code", source_code)

    new_state = Map.put(state, uuid, task_map)
    {:noreply, new_state}
  end

  def handle_call({:has_key, task_id}, _from, state) do
    {:reply, Map.has_key?(state, task_id), state}
  end

  def handle_call({:retrieve_all}, _from, state) do
    {:reply, state, state}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :demand_db)
  end

  # --- user api ----
  def create_demand_record(%{"README" => readme_content, "tests" => test_map, "uuid" => uuid}) do
    GenServer.cast(:demand_db, {:create, {uuid, readme_content, test_map}})
  end

  def has_task_id(task_id) do
    GenServer.call(:demand_db, {:has_key, task_id})
  end

  def update_demand_board(task_id, report, source_code) do
    GenServer.cast(:demand_db, {:update, {task_id, report, source_code}})
  end

  def get_demand_board() do
    GenServer.call(:demand_db, {:retrieve_all})
  end
end

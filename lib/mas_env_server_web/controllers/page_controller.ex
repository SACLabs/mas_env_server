defmodule MasEnvServerWeb.PageController do
  use MasEnvServerWeb, :controller
  import UUID

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def demand_upload(conn, %{"README" => readme_content, "tests" => test_map}) do
    # upload a readme file and a test map
    uuid = UUID.uuid4()

    MasEnvServer.DemandDb.create_demand_record(%{
      "README" => readme_content,
      "tests" => test_map,
      "uuid" => uuid
    })

    conn
    |> put_status(:ok)
    |> json(%{"uuid" => uuid})
  end

  def mas_push_src(conn, %{"task_id" => task_id, "content" => content}) do
    %{
      "result" => %{"code_tree" => code_tree, "code_str" => code_str},
      "history" => history,
      "graph" => graph
    } = content

    # TODO,对于graph和history的处理，暂时不知道怎么做处理，就放在这
    return_json =
      case MasEnvServer.DemandDb.has_task_id(task_id) do
        false ->
          %{"status" => "unknown task id"}

        _ ->
          MasEnvServer.CiRunner.run_ci(task_id, code_tree, code_str)
          %{"status" => "success"}
      end

    conn
    |> put_status(:ok)
    |> json(return_json)
  end

  def get_mas_report_by_id(conn, %{"task_id" => task_id}) do
    result = MasEnvServer.ReportDb.retrieve_report(task_id)

    conn
    |> put_status(:ok)
    |> json(result)
  end
end

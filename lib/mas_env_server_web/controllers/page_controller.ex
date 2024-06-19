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
    # TODO 此处下一个pr完成，将数据存放到env_server的State中
    conn
    |> put_status(:ok)
    |> json(%{"uuid" => uuid})
  end

  def mas_push_src(conn, %{"task_id" => task_id, "content" => content}) do
    # TODO 下一个pr完成对数据的CI/CD过程
    conn
    |> put_status(:ok)
    |> json(%{})
  end

  def get_mas_report_by_id(conn, %{"task_id" => task_id}) do
    # TODO 下一个pr完成给定task_id返回对应的CI/CD结果
    conn
    |> put_status(:ok)
    |> json(%{})
  end
end

defmodule MasEnvServerWeb.PageController do
  use MasEnvServerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def demand(conn, _params) do

  end

  def mas_push_report(conn, _params) do

  end

  def get_mas_report_by_id(conn, _params) do

  end
end

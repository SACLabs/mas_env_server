defmodule MasEnvServer.CiRunner do
  use GenServer
  import Regex

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:run_ci, {task_id, code_tree, code_str}}, state) do
    python_runner_script = Application.app_dir(:mas_env_server, "priv/runner.py")

    {output_str, flag} =
      System.cmd("python", [python_runner_script | [code_tree, Jason.encode!(code_str)]])

    return_report =
      case flag do
        0 ->
          regex =
            regex =
            ~r/\{\s*\"pytest_result\"\s*:\s*\{[\s\S]*\}\s*,\s*\"performance_result\"\s*:\s*\{[\s\S]*\}\}/

          [ci_result_str] = Regex.run(regex, output_str)
          {:ok, ci_result} = Jason.decode(ci_result_str)
          ci_result

        _ ->
          output_str
      end

    MasEnvServer.ReportDb.write_report(task_id, return_report)
    {:noreply, state}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :ci_runner)
  end

  # ---- user api ----
  def run_ci(task_id, code_tree, code_str) do
    MasEnvServer.ReportDb.create_report(task_id)
    GenServer.cast(:ci_runner, {:run_ci, {task_id, code_tree, code_str}})
  end
end

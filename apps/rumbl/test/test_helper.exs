{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.configure formatters: [ExUnit.CLIFormatter, ExUnitNotifier]
ExUnit.configure(timeout: :infinity)

Code.require_file "../../info_sys/test/backends/http_client.exs", __DIR__
ExUnit.start(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Rumbl.Repo, :manual)

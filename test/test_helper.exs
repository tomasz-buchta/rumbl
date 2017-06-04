{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.configure formatters: [ExUnit.CLIFormatter, ExUnitNotifier]
ExUnit.configure(timeout: :infinity)
ExUnit.start(exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Rumbl.Repo, :manual)

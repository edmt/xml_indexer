defmodule XmlIndexer do
  use Application

  # OTP Applications
  def start(_type, _args) do
    IO.puts("Starting the app... #{inspect self}")
    XmlIndexer.Supervisor.start_link
  end
end

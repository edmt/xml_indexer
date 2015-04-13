defmodule XmlIndexer do
  use Application

  require Logger

  # OTP Applications
  def start(_type, _args) do
    Logger.debug("Starting the app... #{inspect self}")
    XmlIndexer.Supervisor.start_link
  end
end

defmodule Squadster.Workers.NotifyAttendants do
  use Task

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(args) do
    # TODO: implement
  end
end

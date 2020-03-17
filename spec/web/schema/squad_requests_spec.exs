defmodule Squadster.Web.Schema.SquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller
  use Phoenix.ConnTest

  import Squadster.Support.Factory

  alias Squadster.Formations.SquadRequest
end

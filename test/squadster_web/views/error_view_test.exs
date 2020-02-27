defmodule SquadsterWeb.ErrorViewTest do
  use SquadsterWeb.ConnCase, async: true
  import Phoenix.View

  test "renders 404.html" do
    assert render(SquadsterWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.html" do
    assert render(SquadsterWeb.ErrorView, "500.json", []) == %{errors: %{detail: "Internal Server Error"}}
  end
end

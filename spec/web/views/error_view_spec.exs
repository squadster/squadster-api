defmodule Squadster.Web.ErrorViewSpec do
  use ESpec.Phoenix, async: true, view: ErrorView

  describe "404.json" do
    let :content do
      render(SquadsterWeb.ErrorView, "404.json", [])
    end

    it "renders json" do
      expect content() |> to(eq %{errors: %{detail: "Not Found"}})
    end
  end

  describe "500.json" do
    let :content do
      render(SquadsterWeb.ErrorView, "500.json", [])
    end

    it "renders json" do
      expect content() |> to(eq %{errors: %{detail: "Internal Server Error"}})
    end
  end
end

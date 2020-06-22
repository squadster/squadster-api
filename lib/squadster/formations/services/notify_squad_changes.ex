defmodule Squadster.Formations.Services.NotifySquadChanges do
  import SquadsterWeb.Gettext
  import Mockery.Macro

  def call(changes, squad, %{id: user_id}) do
    mockable(Squadster.Accounts.Tasks.Notify).start_link([
      message: text(changes),
      target: squad,
      options: [skip: [user_id]]
    ])
  end

  def text(changes) do
    gettext("Squad info has been changed:") <> class_day(changes) <> squad_number(changes) <> advertisment(changes)
  end

  defp class_day(changes) do
    if changes[:class_day] do
      "\n\n" <> gettext(
        "Class day has been updated to %{new_class_day}",
        new_class_day: Gettext.dgettext(SquadsterWeb.Gettext, "days_of_week", Atom.to_string(changes[:class_day]))
      )
    else
      ""
    end
  end

  defp advertisment(changes) do
    if changes[:advertisment] do
      "\n\n" <> gettext("New squad advertisment: %{advertisment}", advertisment: changes[:advertisment])
    else
      ""
    end
  end

  defp squad_number(changes) do
    if changes[:squad_number] do
      "\n\n" <> gettext(
        "Squad number has been changed to %{new_squad_number}.",
        new_squad_number: changes[:squad_number]
      )
    else
      ""
    end
  end
end

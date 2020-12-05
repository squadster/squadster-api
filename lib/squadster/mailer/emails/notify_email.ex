defmodule Squadster.Mailer.Emails.NotifyEmail do
  alias Squadster.MailerView
  
  def html_template(message, user) do
    Phoenix.View.render_to_string(MailerView, "notify.html", %{user: user, message: message})
  end

  def text_template(message, _user) do
    """
    #{message}
    """
  end
end

defmodule Squadster.Mailer do
  @from_email Application.fetch_env!(:squadster, Squadster.Mailer)[:default_from_email]

  @test_config domain: Application.fetch_env!(:squadster, Squadster.Mailer)[:mailgun_domain],
               key: Application.fetch_env!(:squadster, Squadster.Mailer)[:mailgun_key],
               mode: :test,
               test_file_path: "/tmp/mailgun.json"

  @config domain: Application.fetch_env!(:squadster, Squadster.Mailer)[:mailgun_domain],
          key: Application.fetch_env!(:squadster, Squadster.Mailer)[:mailgun_key]

  use Mailgun.Client, if(Mix.env == :test, do: @test_config, else: @config)

  def send(email, subject, text, html) do
    send_email to: email,
               from: @from_email,
               subject: subject,
               text: text,
               html: html
  end
end

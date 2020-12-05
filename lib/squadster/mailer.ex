defmodule Squadster.Mailer do
  @from "noreply@squadster.com"
  @test_config domain: Application.get_env(:squadster, :mailgun_domain),
               key: Application.get_env(:squadster, :mailgun_key),
               mode: :test,
               test_file_path: "/tmp/mailgun.json"

  @config domain: Application.get_env(:squadster, :mailgun_domain),
          key: Application.get_env(:squadster, :mailgun_key)

  use Mailgun.Client, if(Mix.env == :test, do: @test_config, else: @config)
    

  def send(email, subject, text, html) do
    send_email to: email,
               from: @from,
               subject: subject,
               text: text,
               html: html
  end
end

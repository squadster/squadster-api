use Mix.Config

config :squadster, Squadster.Mailer,
  mailgun_domain: EnvHelper.safe_env("MAILGUN_DOMAIN"),
  mailgun_key: EnvHelper.safe_env("MAILGUN_API_KEY"),
  default_from_email: EnvHelper.safe_env("DEFAULT_FROM_EMAIL", "noreply@squadster.com")

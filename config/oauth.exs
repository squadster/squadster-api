use Mix.Config

config :ueberauth, Ueberauth,
  base_path: "/api/auth",
  providers: [
    vk: {Ueberauth.Strategy.VK, [
      profile_fields: "first_name,last_name,bdate,education,universities,domain,photo_400,photo_100"
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.VK.OAuth,
  client_id: EnvHelper.safe_env("VK_APP_ID", "dummy client id"),
  client_secret: EnvHelper.safe_env("VK_SECRET_KEY", "dummy secret"),
  base_redirect_url: EnvHelper.safe_env("FRONTEND_URL", "squadster.wtf:3000") <> "/auth_callback?"

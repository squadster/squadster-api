use Mix.Config

config :ueberauth, Ueberauth,
  base_path: "/api/auth",
  providers: [
    vk: {Ueberauth.Strategy.VK, [profile_fields: "first_name,last_name,bdate,education,universities,domain,photo_400,photo_100"]}
  ]

config :ueberauth, Ueberauth.Strategy.VK.OAuth,
  client_id: System.get_env("VK_APP_ID"),
  client_secret: System.get_env("VK_SECRET_KEY"),
  base_redirect_url: System.get_env("FRONTEND_URL") <> "/auth_callback?"

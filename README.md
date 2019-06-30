# Squadster

It's an application for squads management in university military departments.

### Install locally

First of all you should create OAuth application on [vk.com]("https://vk.com/apps?act=manage"). You will need your application id and secret key from here.

Then you need to add custom hostname to your `/etc/hosts` file. This hostname should be the same with one created in vk application.

As soon as it's done clone the repo and configure environment:
```bash
git clone ...
cd squadster
cp .env.example .env
```
Edit `.env` file and specify all variables marked as `# required`, others are optional and have default values.

Then install dependencies and create database:
```bash
mix deps.get
mix ecto.setup
cd assets && npm install && cd -
```

That's all, run the server with `mix phx.server` and visit [`localhost:4000`](http://localhost:4000) from your browser.

### Deploy

Check [deployment guides](https://hexdocs.pm/phoenix/deployment.html).

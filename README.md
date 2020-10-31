# Squadster

![Logo](https://github.com/squadster/squadster-api/blob/master/logo.png "Hello :)")

Application for facilitation military departments studies.

## The problem it \*will\* solve

No one wants to go to a conscript army, to avoid it students have to attend to military departments in their universities, and no one wants to learn something and care about it because there is completely useless for their life.

But unfortunately if student do nothing he can be expelled from the department or have some problems there.

This application helps students to minimalize care about military studying.

We are against the conscription: 🌸 **Make labs, not war** 🌸

## Installation guides

### Prepare development environment

First of all you should create OAuth application on [vk.com]("https://vk.com/apps?act=manage"). You will need your application id and secret key from here.

Then you need to add custom hostname to your `/etc/hosts` file. This hostname should be the same with one created in vk application. Let it be `squadster.wtf`

As soon as it's done clone the repo and configure environment:

```bash
git clone https://github.com/squadster/squadster-api.git
cd squadster-api
cp .env.sample .env
```

Then edit `.env` file and change variables if needed.

Then install dependencies and create database:

```bash
mix deps.get
mix ecto.setup
```

That's all, load environment with `source .env`, run the server with `mix phx.server` and test it with

```bash
curl squadster.wtf:4000/api/ping
```

### Running test suite

We use [ESpec](https://github.com/antonmi/espec) for testing. To run all specs execute

```bash
mix espec
```

_NOTE: Deprecated Ruby-style syntax fails with OTP 21 and newer, so use Elixir way for it. See [this comment](https://github.com/antonmi/espec/issues/272#issuecomment-399740506)._

### Other parts of application

This repo is only an API part of application. There are also some other parts:

* **Frontend**

Check out [the repo](https://github.com/squadster/squadster-frontend) and it's installation guides.

* **Mercury**

Bot for notifications via [vk.com API](https://vk.com/dev). Check out [the repo](https://github.com/squadster/mercury) and it's installation guides.

### Deployment

We use GitHub packages for deployment.

Check out [Dockerfile](Dockerfile) and [this repo](https://github.com/squadster/squadster-deployment) for more information.

Also check the [Elixir deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Contributing

Your ideas and wishes are welcome via [issues](https://github.com/squadster/squadster-api/issues) and [pull requets](https://github.com/squadster/squadster-api/pulls).

## License

[CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0)

* You cannot use this for commercial purposes.
* If you make your own application based on this you must somehow link this repo on your pages.
* You are not allowed to change license terms

Check out the [LICENCE](LICENSE.md) file

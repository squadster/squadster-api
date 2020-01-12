# Squadster

It's an application for squads management in university military departments.

## The problem it \*will\* solve

No one wants to go to army, that's why students attends to military departments in univercities, and no one wants to learn something and care about it because there is completely useless information.

But unfortunately if student do nothing he can be expelled from the department or have some problems there.

This application helps students to minimalize care about military studying.

🌸 **Make love, not war** 🌸

## Installation guides

### Prepare development environment

First of all you should create OAuth application on [vk.com]("https://vk.com/apps?act=manage"). You will need your application id and secret key from here.

Then you need to add custom hostname to your `/etc/hosts` file. This hostname should be the same with one created in vk application. Let it be `squadster.io`

As soon as it's done clone the repo and configure environment:
```bash
git clone https://github.com/ARtoriouSs/squadster-api.git
cd squadster-api
cp .env.example .env
```
Edit `.env` file and specify all variables marked as `# required`, others are optional, some heve default values.

Then install dependencies and create database:
```bash
mix deps.get
mix ecto.setup
cd assets && npm install && cd -
```

That's all, load environment with `source .env`, run the server with `mix phx.server` and test it with `curl squadster.io/ping`

### Other parts of application

This repo is only an API part of application. There are also some other parts:

* **Frontend**

Check out [the repo](https://github.com/ARtoriouSs/squadster-frontend) and it's installation guides.

* **vk notifier**

Bot for notifications via [vk.com API](https://vk.com/dev). Check out [the repo](TODO: add link) and it's installation guides.

* **Android application**

Check out [the repo](TODO: add link) and it's installation guides..

* **iOS application**

Check out [the repo](TODO: add link) and it's installation guides..

### Deployment

Check the [deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Contributing

Your ideas and wishes are welcome via [issues](https://github.com/ARtoriouSs/squadster-api/issues) and [pull requets](https://github.com/ARtoriouSs/squadster-api/pulls).

**Contributors:**

* TODO:
* add them :)

## License

[CC BY-NC-SA](http://creativecommons.org/licenses/by-nc/4.0)

* You cannot use this for commercial purposes.
* If you make your own application based on this you must somehow link this repo on your pages.
* You are not allowed to change license terms

Check out the [LICENCE](LICENSE.md) file

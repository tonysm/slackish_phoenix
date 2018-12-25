# SlackishPhoenix

I've configured a small setup for docker-compose, just for the database. You can run:

```bash
docker-compose up -d
```

to the database up-and-running.

You will need some config keys, create the `config/dev.secret.exs`:

```elixir
use Mix.Config

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "<YOUR_GOOGLE_CLIENT_ID>",
  client_secret: "<YOUR_GOOGE_CLIENT_SECRET>"
```

Now, follow the common steps.

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

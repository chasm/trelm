# Trelm

[![Greenkeeper badge](https://badges.greenkeeper.io/chasm/trelm.svg)](https://greenkeeper.io/)

You'll need Elixir, Elm, Phoenix, and PostgreSQL.

To start the Phoenix app:

```sh
mix deps.get
mix ecto.create && mix ecto.migrate
npm install
```

To set up Elm:

```sh
cd web/elm
elm package install -y
cd ../..
```

Then run the server with:

```sh
mix phoenix.server
```

Or:

```sh
iex -S mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from the browser.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

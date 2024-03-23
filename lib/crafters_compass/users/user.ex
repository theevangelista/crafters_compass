defmodule CraftersCompass.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession, PowInvitation]

  schema "users" do
    pow_user_fields()

    timestamps()
  end
end

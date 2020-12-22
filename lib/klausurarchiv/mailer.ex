defmodule Klausurarchiv.Mailer do
  use Bamboo.Mailer, otp_app: :klausurarchiv

  def deliver_email(email) do
    email
    |> deliver_now(config: get_environment_config())
  end

  def get_environment_config() do
    case Mix.env() do
      :dev ->
        %{
          server: System.get_env("SMTP_SERVER"),
          hostname: System.get_env("HOST"),
          port: System.get_env("SMTP_PORT"),
          username: System.get_env("SMTP_USERNAME"),
          password: System.get_env("SMTP_PASSWORD")
        }

      _ ->
        %{}
    end
  end
end

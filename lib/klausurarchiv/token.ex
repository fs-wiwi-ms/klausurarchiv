defmodule Klausurarchiv.Token do
  @moduledoc "Module for interacting with tokens (i.e. generating them)"
  @token_length 72

  @doc "Generate a token of the standard token size (#{@token_length} bytes)"
  def generate() do
    @token_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
  end

  @doc "Calculate the time one hour ago"
  def one_hour_ago() do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> Kernel.-(3600)
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end

    @doc "Calculate the time one day ago"
    def one_day_ago() do
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> Kernel.-(86400)
      |> DateTime.from_unix!()
      |> DateTime.to_naive()
    end
end

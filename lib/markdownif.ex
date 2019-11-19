defmodule Markdownif do
  @moduledoc """
  Markdown NIFs
  """

  @chunk_size 2048

  alias Markdownif.Features

  use Rustler, otp_app: :markdownif, crate: :markdownif

  @doc """
  Converts Markdown into HTML

      iex> Markdownif.to_html "__This is markdown__"
      "<p><strong>This is markdown</strong></p>"
  """
  @spec to_html(String.t, Features.t) :: String.t
  def to_html(input, features \\ %Features{}) do
    cond do
      byte_size(input) > @chunk_size ->
        parse_dirty(input, features)
      true ->
        parse(input, features)
    end
  end

  # NIF interface
  # Do not call any of these functions directly, always use
  # Markdownif.to_html/2

  # If the runtime system doesn't support dirty schedulers
  # the NIF would not be loaded

  def parse(_string, _features), do: :erlang.nif_error(:nif_not_loaded)
  def parse_dirty(_string, _features), do: :erlang.nif_error(:nif_not_loaded)
end

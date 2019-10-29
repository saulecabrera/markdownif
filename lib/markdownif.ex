defmodule Markdownif do
  @moduledoc """
  Markdown utilities
  """

  alias Markdownif.Features

  use Rustler, otp_app: :markdownif, crate: :markdownif

  @doc"""
  Converts Markdown into HTML

      iex> Markdownif.to_html "__This is markdown__"
      "<p><strong>This is markdown</strong></p>"
  """
  # TODO: Make features optional
  @spec to_html(String.t, Features.t) :: String.t
  def to_html(_string, _features), do: exit(:nif_not_loaded_error)
end

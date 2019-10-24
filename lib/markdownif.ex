defmodule Markdownif do
  @moduledoc """
  Markdown utilities
  """

  use Rustler, otp_app: :markdownif, crate: :markdownif



  @doc"""
  Converts Markdown into HTML

      iex> Markdownif.to_html "__This is markdown"
      "<p><strong>This is markdown</strong></p>"
  """
  @spec to_html(String.t) :: String.t
  def to_html(_string), do: exit(:nif_not_loaded_error)
end

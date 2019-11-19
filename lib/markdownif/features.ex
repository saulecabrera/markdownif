defmodule Markdownif.Features do
  @type t :: %__MODULE__{
          tables: boolean,
          footnotes: boolean,
          strikethrough: boolean,
          tasklists: boolean
        }

  defstruct tables: false,
            footnotes: false,
            strikethrough: false,
            tasklists: false
end

defmodule MarkdownifTest do
  alias Markdownif.Features
  use ExUnit.Case
  doctest Markdownif

  setup do
    tasklist = """
    - [ ] A
    """

    strikethrough = "~~striked~~"

    table = """
    | Tables        | Are           | Cool  |
    | ------------- |:-------------:| -----:|
    | foo           | bar           |    $1 |
    """

    footnote = """
    Lorem ipsum.[^a]

    [^a]: Definition.
    """

    [
      tasklist: tasklist,
      strikethrough: strikethrough,
      table: table,
      footnote: footnote
    ]
  end

  describe "to_html/2" do
    test "additional markdown features are disabled by default", context do
      tasklist = Markdownif.to_html(context[:tasklist])
      refute String.contains?(tasklist, ["input", "type", "checkbox"])

      strikethrough = Markdownif.to_html(context[:strikethrough])
      refute String.contains?(strikethrough, ["<del>", "</del>"])

      table = Markdownif.to_html(context[:table])
      refute String.contains?(table, ["<table>", "</table>"])
    end

    test "tasklists are correctly rendered", context do
      tasklist = Markdownif.to_html(context[:tasklist], %Features{tasklists: true})
      assert String.contains?(tasklist, ["input", "type", "checkbox"])
    end

    test "strikethrough is correctly rendered", context do
      striked = Markdownif.to_html(context[:strikethrough], %Features{strikethrough: true})
      assert String.contains?(striked, ["<del>", "</del>"])
    end

    test "tables are correctly rendered", context do
      table = Markdownif.to_html(context[:table], %Features{tables: true})
      assert String.contains?(table, ["<table>", "</table>"])
    end
  end
end

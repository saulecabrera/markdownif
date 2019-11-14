input = File.read! "#{__DIR__}/example.md"

Benchee.run(
  %{
    "Markdownif.to_html/1" => fn -> Markdownif.to_html(input, %Markdownif.Features{}) end,
  },
  time: 10
)

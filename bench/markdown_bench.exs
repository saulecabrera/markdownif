input = File.read! "#{__DIR__}/example.md"
input_size = "#{byte_size(input)} bytes"

chunk_size = 2049
<< chunk :: binary-size(chunk_size), _ :: binary >> = input

Benchee.run(
  %{
    "Markdownif.to_html/1: #{input_size}" => fn -> Markdownif.to_html(input, %Markdownif.Features{}) end,
    "Markdownif.to_html/1: #{chunk_size} bytes" => fn -> Markdownif.to_html(chunk, %Markdownif.Features{}) end,
  },
  time: 10
)

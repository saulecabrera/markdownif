# Markdownif

[![Build Status](https://github.com/saulecabrera/markdownif/workflows/CI/badge.svg)](https://github.com/saulecabrera/markdownif/actions)


Markdown NIFs built on top of [pulldown-cmark](https://github.com/raphlinus/pulldown-cmark) using [Rustler](https://github.com/rusterlium/rustler).


## Installation

In your `deps` add:

```elixir
{:markdownif, "~> 0.9.0"}
```

## Features

- Fast
- Safe: the bindings are written in Rust using [Rustler](https://github.com/rusterlium/rustler)

## Usage

This library implements bindings for [pulldown-cmark](https://github.com/raphlinus/pulldown-cmark) which is a pull parser for [CommonMark](https://commonmark.org/).

It supports the following optional features:

- Foonote parsing
- GitHub flavored tasklists
- Github flavored tables
- Strikethrough


To convert a markdown string into HTML use `Markdownif.to_html/2`:

```elixir
Markdownif.to_html("__Foo__")

<p><strong>Foo</strong></p>
```

All optional features all disabled by default, to enable any of them pass a `%Markdownif.Features{}` struct as a second parameter to `Markdownif.to_html/2`:


- `Markdownif.to_html(input, %Markdownif.Features{footnotes: true})` to enable footnote parsing
- `Markdownif.to_html(input, %Markdownif.Features{tables: true})` to enable table support
- `Markdownif.to_html(input, %Markdownif.Features{tasklists: true})` to enable tasklist support 
- `Markdownif.to_html(input, %Markdownif.Features{strikethrough: true})` to enable strikethrough support

### Input size and dirty scheduling

Markdownif makes use of dirty schedulers to handle long running NIFs.

To avoid any unexpected behaviour in the VM, the Erlang team recommends that NIFs should be as fast as possible, ideally they should run within 1ms, if this is not possible,
work should be chunked or the function should be flagged as a dirty NIF.

In the case of this library, since chunking is not an option, dirty NIFs are used instead. Two main factors are taken into account to decide when to flag the execution as dirty:

- Input size
- Dirty scheduling overhead

When loading a dirty NIF the execution doesn't take place right away, instead it's enqueued into the run queue of a dirty scheduler, this is not a free operation.

Roughly, the following calls are made:

1. `static_schedule_dirty_cpu_nif` performs the NIF scheduling
2. `erts_call_dirty_nif` calls the NIF
3. `dirty_nif_finalizer` returns the result of the NIF

[This post](https://medium.com/@jlouis666/erlang-dirty-scheduler-overhead-6e1219dcc7) suggests that instead of relying on the 1ms rule for dirty scheduling, it's viable to use dirty schedulers when the dirty scheduling overhead is low enough that it's not significant to the overall NIF execution time. That is when the scheduling overhead is 10% or less of the overall execution time. 

In this case, running the [tracing script](https://github.com/saulecabrera/markdownif/blob/master/bench/trace_dirty_nif.d) shows that with an input of 2049 bytes the scheduling overhead is 3250ns and the total execution time is 26500ns; the overhead represents ~12% of the total execution time. 

Taking all this into account, dirty schedulers will be used with all inputs greater than 2048 bytes.

## Benchmarks

The following benchmark results compares Markdownif to [markdown](https://github.com/devinus/markdown) and [earmark](https://github.com/pragdave/earmark)

```sh
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.9.1
Erlang 21.0

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 10 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 1.20 min

Benchmarking Earmark.as_html!/1 120027 bytes bytes...
Benchmarking Earmark.as_html!/1 2049 bytes...
Benchmarking Markdown.to_html/1 120027 bytes bytes...
Benchmarking Markdown.to_html/1 2049 bytes...
Benchmarking Markdownif.to_html/1: 120027 bytes bytes...
Benchmarking Markdownif.to_html/1: 2049 bytes...

Name                                               ips        average  deviation         median         99th %
Markdown.to_html/1 2049 bytes                 38275.79      0.0261 ms    ±40.58%      0.0240 ms      0.0640 ms
Markdownif.to_html/1: 2049 bytes              33590.81      0.0298 ms    ±48.69%      0.0270 ms      0.0800 ms
Markdown.to_html/1 120027 bytes bytes           939.05        1.06 ms    ±10.10%        1.02 ms        1.47 ms
Markdownif.to_html/1: 120027 bytes bytes        868.94        1.15 ms    ±12.93%        1.12 ms        1.70 ms
Earmark.as_html!/1 2049 bytes                   163.35        6.12 ms    ±11.52%        5.97 ms        9.22 ms
Earmark.as_html!/1 120027 bytes bytes             5.24      190.74 ms     ±3.63%      189.62 ms      229.73 ms

Comparison:
Markdown.to_html/1 2049 bytes                 38275.79
Markdownif.to_html/1: 2049 bytes              33590.81 - 1.14x slower +0.00364 ms
Markdown.to_html/1 120027 bytes bytes           939.05 - 40.76x slower +1.04 ms
Markdownif.to_html/1: 120027 bytes bytes        868.94 - 44.05x slower +1.12 ms
Earmark.as_html!/1 2049 bytes                   163.35 - 234.32x slower +6.10 ms
Earmark.as_html!/1 120027 bytes bytes             5.24 - 7300.72x slower +190.71 ms

```


## LICENSE

MIT License

Copyright (c) 2019 Saúl Cabrera


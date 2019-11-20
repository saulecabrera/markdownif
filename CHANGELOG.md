# Changelog

All notable changes to this project will be documented on this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.9.0] - 2019-11-20

- Beta
- First documented version

### Added

- [Native] [pulldown-cmark](https://github.com/raphlinus/pulldown-cmark) as the underlying Rust crate for Markdown
- [Native + Markdownif] Support for pulldown-cmark features: tasklists, footnotes, tables, strikethrough
- [Native] `parse/2` and `parse_dirty/2` NIFs
- [Markdownif] `Markdownif.to_html/2` public function
- [Markdownif] 1024 bytes as the threshold for dirty scheduling
- [Benchmarks] Dirty NIF scheduling overhead tracing


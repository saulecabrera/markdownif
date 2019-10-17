mod atoms;
mod md;

use rustler::{Env, Term};

rustler::rustler_export_nifs! {
    "Elixir.Markdownif",
    [
        ("to_html", 1, md::to_html),
        ("tokenize", 1, md::tokenize)
    ],
    Some(on_load)
}

fn on_load(_env: Env, _info: Term) -> bool {
    true
}


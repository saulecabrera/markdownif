mod atoms;
mod md;

use rustler::{Env, Term};

rustler::rustler_export_nifs! {
    "Elixir.Markdownif",
    [
        ("to_html", 2, md::to_html),
    ],
    Some(on_load)
}

fn on_load(_env: Env, _info: Term) -> bool {
    true
}


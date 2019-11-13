mod atoms;
mod md;

use rustler::{Env, Term, SchedulerFlags};

rustler::rustler_export_nifs! {
    "Elixir.Markdownif",
    [
        ("parse", 2, md::parse),
        ("parse_dirty", 2, md::parse, SchedulerFlags::DirtyCpu),
    ],
    Some(on_load)
}

fn on_load(_env: Env, _info: Term) -> bool {
    true
}

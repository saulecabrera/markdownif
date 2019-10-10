extern crate markdown;

use rustler::{Encoder, Env, Error, Term};

rustler::rustler_export_nifs! {
    "Elixir.Markdownif",
    [
        ("to_html", 1, to_html)
    ],
    None
}

fn to_html<'a>(env: Env<'a>, args: &[Term]) -> Result<Term<'a>, Error>  {
    args[0]
        .decode()
        .and_then(|arg: String| {
            Ok(markdown::to_html(&arg).encode(env))
        })
}

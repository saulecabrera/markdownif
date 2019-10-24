use crate::atoms;
use rustler::{Env, Error, Term, Encoder};
use pulldown_cmark::{Parser, Options, html};

pub fn to_html<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error>  {
    args[0]
        .decode()
        .and_then(|input: String| {
            let parser = Parser::new_ext(&input, Options::empty());
            let mut output = String::new();
            html::push_html(&mut output, parser);

            Ok(output.encode(env))
        })
}

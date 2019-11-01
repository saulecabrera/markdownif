use crate::atoms;
use rustler::{Env, Error, Term, Encoder, NifStruct};
use pulldown_cmark::{Parser, Options, html};

#[derive(NifStruct)]
#[module = "Markdownif.Features"]
struct Features {
    pub tables: bool,
    pub footnotes: bool,
    pub strikethrough: bool,
    pub tasklists: bool,
}

pub fn to_html<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error>  {
    let input: &str = args[0].decode()?;
    let features: Features = args[1].decode()?;


    let mut opts = Options::empty();
    if features.strikethrough {
        opts.insert(Options::ENABLE_STRIKETHROUGH);
    }

    if features.tasklists {
        opts.insert(Options::ENABLE_TASKLISTS);
    }

    if features.footnotes {
        opts.insert(Options::ENABLE_FOOTNOTES);
    }

    if features.tables {
        opts.insert(Options::ENABLE_TABLES);
    }

    let mut output = String::new();
    html::push_html(&mut output, Parser::new_ext(
        &input,
        opts
    ));

    Ok(output.encode(env))
}

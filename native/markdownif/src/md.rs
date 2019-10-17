use crate::atoms;
use rustler::{Env, Error, Term, Encoder};
use markdown::{Block, ListItem, Span};

pub fn to_html<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error>  {
    args[0]
        .decode()
        .and_then(|arg: String| {
            Ok(markdown::to_html(&arg).encode(env))
        })
}

pub fn tokenize<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    args[0]
        .decode()
        .and_then(|input: String| {
            Ok(markdown::tokenize(&input))
        })
        .and_then(|tokens| {
            Ok(encode_block(env, &tokens).encode(env))
        })
}

fn encode_block<'a>(env: Env<'a>, tokens: &Vec<Block>) -> Vec<Term<'a>> {
    tokens.iter().map(|token| {
        match token {
            Block::Header(children, size) => {
                (atoms::header(), size, encode_span(env, &children)).encode(env)
            },
            Block::Paragraph(children) => {
                (atoms::p(), encode_span(env, &children)).encode(env)
            },
            Block::Blockquote(children) => {
                (atoms::quote(), encode_block(env, &children)).encode(env)
            },
            Block::CodeBlock(string) => {
                (atoms::codeblock(), string).encode(env)
            },
            Block::UnorderedList(children) => {
                (atoms::ul(), encode_list_item(env, &children)).encode(env)
            },
            Block::Raw(string) => {
                (atoms::raw(), string).encode(env)
            },
            Block::Hr => atoms::hr().encode(env)
        }
    }).collect()
}

fn encode_span<'a>(env: Env<'a>, tokens: &Vec<Span>) -> Vec<Term<'a>> {
    tokens.iter().map(|token| {
        match token {
            Span::Break => atoms::br().encode(env),
            Span::Text(string) => (atoms::text(), string).encode(env),
            Span::Code(string) => (atoms::code(), string).encode(env),
            Span::Link(a, b, c) => (atoms::link(), a, b, c).encode(env),
            Span::Image(a, b, c) => (atoms::img(), a, b, c).encode(env),
            Span::Emphasis(children) => (atoms::em(), encode_span(env, &children)).encode(env),
            Span::Strong(children) => (atoms::b(), encode_span(env, &children)).encode(env)
        }
    }).collect()
}

fn encode_list_item<'a>(env: Env<'a>, tokens: &Vec<ListItem>) -> Vec<Term<'a>> {
    tokens.iter().map(|token| {
        match token {
            ListItem::Simple(children) => (atoms::li(), encode_span(env, &children)).encode(env),
            ListItem::Paragraph(children) => (atoms::li(), encode_block(env, &children)).encode(env),
        }
    }).collect()
}

use backtrace::Backtrace;
use std::{error::Error as StdError, fmt::Debug, io};

pub(crate) type CrateResult = Result<(), Error>;

pub(crate) struct Error {
    source: Option<Box<dyn StdError>>,
    bt: Backtrace,
    message: Option<String>,
}

impl Error {
    #[track_caller]
    pub(crate) fn new_file_io(src: io::Error, filename: String) -> Self {
        Error {
            message: Some(filename),
            source: Some(Box::new(src)),
            bt: Backtrace::new(),
        }
    }

    #[track_caller]
    pub(crate) fn new_generic(src: impl std::error::Error + 'static) -> Self {
        Error {
            message: Some(src.to_string()),
            source: Some(Box::new(src)),
            bt: Backtrace::new(),
        }
    }
}

impl Debug for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut src: Option<&dyn StdError> = self.source.as_deref();
        let mut indentation_levels = 0;

        if let Some(message) = &self.message {
            f.write_str(message)?;
        }

        while let Some(source) = src {
            f.write_str("\n")?;

            for _ in 0..=indentation_levels {
                f.write_str("  ")?;
            }

            f.write_fmt(format_args!("Caused by: {}\n", source))?;

            indentation_levels += 1;
            src = source.source();
        }

        f.write_fmt(format_args!("{:?}\n", self.bt))
    }
}

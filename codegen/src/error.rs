use std::{error::Error as StdError, fmt::Debug, panic::Location};

pub(crate) type CrateResult = Result<(), Error>;

pub(crate) struct Error {
    source: Option<Box<dyn StdError>>,
    origin: &'static Location<'static>,
    message: Option<String>,
}

impl<T> From<T> for Error
where
    T: StdError + 'static,
{
    #[track_caller]
    fn from(err: T) -> Self {
        Error {
            message: Some(err.to_string()),
            source: Some(Box::new(err)),
            origin: Location::caller(),
        }
    }
}

impl Debug for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut src: Option<&dyn StdError> = self.source.as_deref();
        let mut indentation_levels = 0;

        if let Some(message) = &self.message {
            f.write_fmt(format_args!("{:?}", self.origin))?;
            f.write_str(message)?;
        }

        while let Some(source) = src {
            f.write_str("\n")?;

            for _ in 0..=indentation_levels {
                f.write_str("  ")?;
            }

            f.write_fmt(format_args!("Caused by: {:?}", source))?;

            indentation_levels += 1;
            src = source.source();
        }

        Ok(())
    }
}

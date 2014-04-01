# ruby-core-docs

## Purpose

Automatically generates YARD documentation databases for MRI.

## Usage

Follow these steps in order:

### rake download

Downloads ruby source tarballs to `rubies/`. You can do this manually, if you like.

### rake docs

Extracts each tarball to `src/`, generates YARD documentation, the moves the yard database to `cache/<ruby-version>` (eg: `cache/2.1.1`).

### rake build

Builds a gem for each directory in `cache/`.

If you need to yank a gem and replace it, you can append a new number to the end of the gem version by passing a parameter to build: `rake build[n]`

eg: `rake build[2]` would produce `ruby-core-docs-2.1.0.2.gem`)

### rake release

Send `*.gem` to kindgom come!!!
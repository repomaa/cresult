# cresult

Cresult is an adaptation of [Rust's error
handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html) for
Crystal.

## Why and when should you be using it?

Raising exceptions is expensive: The stack pointer must be saved, an interrupt
is triggered, the exception handler is called, and so forth.

If you deal with a lot of unsafe runtime inputs or anything else that throws
exceptions frequently enough, you might consider using this shard.

Enough talk, time for irrelevant micro benchmarks!

```
with exception 490.50k (  2.04µs) (± 5.69%)  185B/op  537.16× slower
   with result 262.98M (  3.80ns) (± 4.84%)  0.0B/op    1.00× slower
   never raise 251.48M (  3.98ns) (± 1.94%)  0.0B/op    1.05× slower
     never Err 263.48M (  3.80ns) (± 3.03%)  0.0B/op         fastest
```

This is quite something! Please note though, that here statistically every
second call throws an exception (or results in an Err). This is a big percentage
and your real world application will have a much lower error rate and as such
the difference won't be as dramatic. What's more: even for methods that never
raise (or produce an Err) there's no overhead!

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cresult:
       github: repomaa/cresult
   ```

2. Run `shards install`

## Usage

```crystal
require "cresult"

# include Cresult on top level or in the namespace you want to use it
include Cresult

# The return type of this method will be inferred as Ok(Float64) | Err(Exception)
def might_work
  result = rand

  if result > 0.5
    Ok[result] # Syntax sugar for Ok.new(result)
  else
    Err["Something went wrong"] # Syntax sugar for Err.new("Something went wrong")
    # Alternatively you also pass an actual exception object
    # ```
    # Err[KeyError.new("missing key")]
    # ```
  end
end

# The return type of this method will be inferred as Ok(Float64) | Err(Exception)
def using_might_work
  # If `might_work` evaluates to an `Err` it is
  # immediately returned by the method (or propagated), if it's an `Ok`, the
  # macro evaluates to the underlying value (and here will be assigned to
  # result)
  # It behaves just like Rust's `?` operator
  result = try! might_work

  # do something with result

  Ok[result]
end
```

## Contributing

1. Fork it (<https://github.com/repomaa/cresult/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Joakim Repomaa](https://github.com/repomaa) - creator and maintainer

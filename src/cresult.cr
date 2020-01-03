# TODO: Write documentation for `Cresult`
module Cresult
  VERSION = "0.1.0"

  macro try!(result_value)
    %value = {{result_value}}
    return %value if %value.is_a?(Err)
    %value.unwrap
  end

  module ResultMethods
    abstract def unwrap
  end

  struct Ok(T)
    include ResultMethods

    def self.[](value)
      new(value)
    end

    def initialize(@value : T)
    end

    def unwrap
      @value
    end
  end

  struct Err(T)
    include ResultMethods

    def self.[](exception)
      new(exception)
    end
    def initialize(@exception : T)
    end

    def unwrap
      raise @exception
    end
  end
end

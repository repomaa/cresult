require "benchmark"
require "../src/cresult"

include Cresult

def with_exception_level_100
  rand.tap { |number| raise "invalid result" if number > 0.5 }
end

def with_result_level_100
  Ok[rand.tap { |number| return Err["invalid result"] }]
end

{% for i in 1..99 %}
  def with_exception_level_{{i}}
    result = with_exception_level_{{i + 1}} + 1
    result * 2
  end

  def with_result_level_{{i}}
    result = try!(with_result_level_{{i + 1}}) + 1
    Ok[result * 2]
  end
{% end %}

Benchmark.ips do |x|
  x.report("with exception") do
    begin
      with_exception_level_1 + 1
    rescue
    end
  end

  x.report("with result") do
    result = with_result_level_1
    case result
    when Ok then result.unwrap + 1
    end
  end
end

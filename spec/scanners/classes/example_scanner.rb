require 'ronin/scanners/scanner'

class ExampleScanner

  include Ronin::Scanners::Scanner

  scanner(:test1) do |target,results|
    results.call(1)
  end

  scanner(:test2) do |target,results|
    results.call(2)
  end

  scanner(:test2) do |target,results|
    results.call(4)
  end

  scanner(:fail) do |target,results|
  end

end

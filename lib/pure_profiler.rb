module PureProfiler
  class Profiler
    attr_reader :sample_rate, :samples

    def initialize(sample_rate: 0.001)
      @sample_rate = sample_rate
      @samples = []
    end

    def start
      start_thread
    end

    def start_thread
      @thread = Thread.new do
        loop do
          @samples << Thread.main.backtrace_locations
          sleep @sample_rate
        end
      end
    end

    def stop
      @thread.kill
    end

    def print_results
      total_samples =
        @samples.flat_map { _1.map(&:label).uniq }.tally
      total_self =
        @samples.flat_map { _1.first.label }.tally
      #sample_to_pct = 100.0 / @samples.size

      puts " total   self  name"
      total_samples.sort_by(&:last).reverse_each do |name, total_samples|
        self_samples = total_self.fetch(name, 0)

        puts "%6i %6i  %s" % [total_samples, self_samples, name]
      end
    end
  end
end

profiler = PureProfiler::Profiler.new
profiler.start

at_exit do
  profiler.stop
  profiler.print_results
end

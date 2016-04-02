module Ec2named
  class InstanceAge
    def initialize(launch_time)
      @launch_time = launch_time
      @time_diff = nil_to_zero(Time.diff(launch_time, Time.now))

      time_diff.each_pair do |time_component, time_component_value|
        define_singleton_method(time_component) do
          time_component_value
        end
      end
    end

    attr_reader :launch_time, :time_diff

    def nil_to_zero(hash)
      hash.each_with_object({}) { |(k, v), o| o[k] = (v.nil? ? 0 : v) }
    end
  end
end

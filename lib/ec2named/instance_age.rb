module Ec2named
  class InstanceAge
    def initialize(launch_time)
      @launch_time = launch_time
      @time_diff = Time.diff(launch_time, Time.now)

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

    def ymw_day
      @ymw_day ||= year * 365 + month * 30 + week * 7 + day
    end

    def to_s
      hms = [hour, minute, second].map { |t| '%02d' % t }
      hms.unshift(ymw_day) if ymw_day > 0
      hms.join(":")
    end
  end
end

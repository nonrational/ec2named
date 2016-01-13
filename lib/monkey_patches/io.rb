# encoding: utf-8
# frozen_string_literal: true

class IO
  def print_flush(str)
    print str
    flush
  end
end

require 'rubygems'

module Puppet::Parser::Functions

  class GlusterFunctions

    def initialize(volume_data)
      @volume_data  = volume_data 
    end

    def formatBricks()
      r = ''
      @volume_data .each do |k,v|
        mountpoint = v['mountpoint']
        r += "#{k}:#{mountpoint} "
      end
      return  r[0..-2]
    end
  end

  newfunction(:glusterFunctions, :type => :rvalue) do |args|
    volume_data = args[0]
    action  = args[1]

    g = GlusterFunctions.new(volume_data)
    case action
    when 'formatBricks'
      return g.formatBricks()
    end
  end
end

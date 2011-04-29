module DiffStat
  class Parser
    def initialize(diff)
      @diff = diff
    end

    def parse
      result = []
      stat = nil
      additions = 0
      deletions = 0
      modifications = 0
      @diff.each_line do |line|
        case line
        when /^\+{3} (.*?)\s+.*/
          stat = Stat.new
          stat.name = $1
          previous = nil
          result << stat
        when /^\-{3} .*/

        when /^ .*/, /^\n$/, /^\r\n$/ #context line or EOF
          modifications = [additions, deletions].min
          additions -= modifications
          deletions -= modifications
          stat.additions += additions
          stat.deletions += deletions
          stat.modifications += modifications
          additions, deletions, modifications = 0, 0, 0
        when /^\+.*/
          additions += 1
        when /^\-.*/
          deletions += 1
        end
      end
      result
    end
  end

  class Stat
    attr_accessor :name, :additions, :deletions, :modifications

    def initialize
      @name, @additions, @deletions, @modifications = '', 0, 0, 0
    end
  end

end

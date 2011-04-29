module DiffStat
  class Parser
    def initialize(diff)
      @diff = diff
      @additions, @deletions = 0, 0
    end

    def parse
      result = []
      stat = nil
      @diff.each_line do |line|
        case line
        when /^\+{3} (.*?)\s+.*/
          stat = Stat.new
          stat.name = $1
          result << stat
        when /^\-{3} .*/

        when /^ .*/, /^\n$/, /^\r\n$/ #context line or EOF
          stat.additions += @additions - modifications
          stat.deletions += @deletions - modifications
          stat.modifications += modifications
          @additions, @deletions = 0, 0
        when /^\+.*/
          @additions += 1
        when /^\-.*/
          @deletions += 1
        end
      end
      result
    end

    def modifications
      [@additions, @deletions].min
    end
  end

  class Stat
    attr_accessor :name, :additions, :deletions, :modifications

    def initialize
      @name, @additions, @deletions, @modifications = '', 0, 0, 0
    end
  end

end

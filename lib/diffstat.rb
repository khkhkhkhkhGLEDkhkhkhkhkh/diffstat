module DiffStat

  def self.stat(diff)
    Parser.new(diff).parse
  end

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
          update(stat) if stat

          stat = Stat.new
          stat.name = $1
          result << stat
        when /^\-{3} .*/

        when /^ .*/, /^\n$/, /^\r\n$/ #context line or EOF
          update(stat)
        when /^\+.*/
          @additions += 1
        when /^\-.*/
          @deletions += 1
        end
      end
      update(stat)
      result
    end

    private 

    def modifications
      [@additions, @deletions].min
    end

    def update(stat)
      stat.additions += @additions - modifications
      stat.deletions += @deletions - modifications
      stat.modifications += modifications
      @additions, @deletions = 0, 0
    end
  end

  class Stat
    attr_accessor :name, :additions, :deletions, :modifications

    def initialize
      @name, @additions, @deletions, @modifications = '', 0, 0, 0
    end
  end

end

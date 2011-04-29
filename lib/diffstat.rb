module DiffStat
  class Parser
    def initialize(diff)
      @diff = diff
    end

    def parse
      result = []
      stat = nil
      previous = nil
      @diff.each_line do |line|
        case line
        when /^\+{3} (.*?)\s+\(revision .*/
          stat = Stat.new
          stat.name = $1
          previous = nil
          result << stat
        when /^\-{3} .*/

        when /^ .*/
          previous = :c
        when /^\+.*/
          stat.additions += 1 if previous != :-
          if previous == :-
            stat.modifications += 1
            stat.deletions -= 1
          end
          previous = :+
        when /^\-.*/
          stat.deletions += 1
          previous = :-
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

module DiffStat
  class Parser
    def initialize(diff)
      @diff = diff
    end

    def parse
      []
    end
  end

  Stat = Struct.new(:name, :additions, :deletions, :modifications)
end

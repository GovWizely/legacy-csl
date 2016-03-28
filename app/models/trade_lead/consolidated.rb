module TradeLead
  class Consolidated
    include Findable
    include Searchable
    self.model_classes = [TradeLead::Australia,
                          TradeLead::Canada,
                          TradeLead::Fbopen,
                          TradeLead::State,
                          TradeLead::Uk,
                          TradeLead::Mca,
                          TradeLead::Ustda,]
  end
end

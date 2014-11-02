module ScreeningList
  class Uvl
    extend ::Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Unverified List (UVL) - Bureau of Industry and Security',
      code:      'UVL',
    }
  end
end

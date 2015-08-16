module Envirotech
  class EnvirotechToolkitData
    RELATION_DATA = "#{Rails.root}/data/envirotech/issue_solution_regulation.json"

    def import
      Envirotech::IssueData.new.import
      Envirotech::BackgroundLinkData.new.import
      Envirotech::AnalysisLinkData.new.import
      Envirotech::ProviderData.new.import

      # Fixme: this solution is valid until we have full control over the toolkit
      local_data = JSON.parse(open(RELATION_DATA).read)
      scraper_data = Envirotech::ToolkitScraper.new.all_issue_info

      if scraper_data.present? && scraper_data.deep_stringify_keys != local_data
        Airbrake.notify(EnvirotechToolkitDataMismatch.new)
      end

      if scraper_data.blank?
        scraper_data = local_data
        Airbrake.notify(EnvirotechToolkitNotFound.new)
      end

      Envirotech::RegulationData.new(scraper_data).import
      Envirotech::SolutionData.new(scraper_data).import
      Envirotech::ProviderSolutionData.new.import
    end
  end
end

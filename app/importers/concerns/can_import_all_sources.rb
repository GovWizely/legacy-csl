module CanImportAllSources
  extend ActiveSupport::Concern

  module ClassMethods
    def importers
      module_importer_files =
        "#{Rails.root}/app/importers/#{name.typeize}/*"
      Dir[module_importer_files].each { |f| require f }

      constants
        .map { |constant| const_get(constant) }
        .select { |klass| klass.include?(Importable) && !klass.disabled? }
    end

    def import_all_sources
      rescued_errors = []
      
      importers.each do |i|
        begin
          i.new.import
        rescue => e
          Rails.logger.error e
          rescued_errors.push e
        end
      end

      rescued_errors
    end
  end
end

class ES
  INDEX_PREFIX = "#{Rails.env}:webservices".freeze

  def self.client
    @@client ||= Elasticsearch::Client.new url: Rails.configuration.csl.elasticsearch.url,
                                           log: Rails.configuration.csl.elasticsearch.log
  end
end

Elasticsearch::Model.client = ES.client

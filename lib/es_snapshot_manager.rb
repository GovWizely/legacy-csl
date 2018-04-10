module ESSnapshotManager
  def self.restore(aws_params, snapshot_name) # rubocop:disable Metrics/MethodLength
    index_pattern = "#{Rails.env}:webservices:screening_list:*,#{Rails.env}:webservices:url_mappers*"
    close_indices_with_open_status index_pattern

    repository_name = "repo_#{Time.now.strftime('%Y%m%d_%H%M%S')}"

    execute_on_repository(aws_params, repository_name) do
      ES.client.snapshot.restore repository:          repository_name,
                                 snapshot:            snapshot_name,
                                 wait_for_completion: true,
                                 body:                {
                                   indices: index_pattern,
                                 }
    end
    replica_count = [get_data_nodes_count - 1, 0].max
    set_number_of_replicas index_pattern, replica_count
  end

  def self.close_indices_with_open_status(index_pattern)
    indices = ES.client.cat.indices index: index_pattern, format: 'json'
    ES.client.indices.close(index: index_pattern) if indices.select { |i| i['status'] == 'open' }.present?
  end

  def self.execute_on_repository(aws_params, repository_name, &_block)
    ES.client.snapshot.create_repository create_repository_params(aws_params, repository_name)
    begin
      yield
    ensure
      ES.client.snapshot.delete_repository repository: repository_name
    end
  end

  def self.create_repository_params(aws_params, repository_name) # rubocop:disable Metrics/MethodLength
    {
      repository: repository_name,
      body:       {
        type:     's3',
        settings: {
          access_key: aws_params[:access_key],
          bucket:     aws_params[:bucket],
          readonly:   true,
          region:     aws_params[:region],
          secret_key: aws_params[:secret_key],
        },
      },
    }
  end

  def self.set_number_of_replicas(index_pattern, replica_count)
    ES.client.indices.put_settings index: index_pattern,
                                   body: {
                                     index: {
                                       number_of_replicas: replica_count
                                     }
                                   }
  end

  def self.get_data_nodes_count
    ES.client.cluster.stats['nodes']['count']['data']
  end
end

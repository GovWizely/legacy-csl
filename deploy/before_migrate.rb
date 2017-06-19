deploy = new_resource
env_vars = new_resource.environment

template_config = {
  'csl.yml' => {
    environment: env_vars['RACK_ENV'],
    aws_access_key_id: env_vars['aws_access_key_id'],
    aws_secret_access_key: env_vars['aws_secret_access_key'],
    aws_region: node['csl']['aws']['region'],
    bitly_api_token: env_vars['bitly_api_token'],
    elasticsearch_url: node['csl']['elasticsearch']['url']
  }
}

template_config.each do |filename, vars|
  template "#{deploy.deploy_to}/shared/config/#{filename}" do
    source "#{release_path}/config/#{filename}.erb"
    local true
    mode '0400'
    group deploy.group
    owner deploy.user
    variables vars
  end
end

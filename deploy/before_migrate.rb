deploy = new_resource
env_vars = new_resource.environment

template_config = {
  'config/airbrake.yml' => {
    environment: env_vars['RACK_ENV'],
    project_id: env_vars['airbrake_project_id'],
    project_key: env_vars['airbrake_project_key']
  },
  'config/initializers/airbrake.rb' => {},
  'config/csl.yml' => {
    environment: env_vars['RACK_ENV'],
    aws_access_key_id: env_vars['aws_access_key_id'],
    aws_secret_access_key: env_vars['aws_secret_access_key'],
    aws_region: node['csl']['aws']['region'],
    bitly_api_token: env_vars['bitly_api_token'],
    elasticsearch_url: node['csl']['elasticsearch']['url']
  },
  'config/newrelic.yml' => {
    environment: env_vars['RACK_ENV'],
    license_key: env_vars['newrelic_license_key']
  }
}

template_config.each do |path, vars|
  template "#{deploy.deploy_to}/shared/#{path}" do
    source "#{release_path}/#{path}.erb"
    local true
    mode '0400'
    group deploy.group
    owner deploy.user
    variables vars
  end
end

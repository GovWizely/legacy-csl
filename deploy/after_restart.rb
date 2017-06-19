revision = `cd #{release_path} && git rev-parse HEAD`.chomp

deploy = {
  'user' => new_resource.user,
  'group' => new_resource.group,
  'cwd' => release_path,
  'environment' => {
    'PATH' => "/home/#{new_resource.user}/.rbenv/shims:/usr/bin:/bin",
    'RACK_ENV' => new_resource.environment['RACK_ENV'],
    'REPOSITORY' => new_resource.repo,
    'REVISION' => revision,
    'USERNAME' => new_resource.user
  }
}

track_deployment = node['csl']['track_deployment']

execute 'rake airbrake:deploy' do
  user deploy['user']
  group deploy['group']
  cwd deploy['cwd']
  environment deploy['environment']
  command "bundle exec rake airbrake:deploy TO=#{new_resource.environment['RACK_ENV']}"
  only_if { track_deployment }
end

execute 'newrelic deployments' do
  user deploy['user']
  group deploy['group']
  cwd deploy['cwd']
  environment deploy['environment']
  command "bundle exec newrelic deployments -u #{deploy['user']} -r #{revision}"
  only_if { track_deployment }
end

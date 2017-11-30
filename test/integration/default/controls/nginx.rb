# Ensure Nginx is running and will start at boot.
describe service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Ensure nginx is listening - assumes SSL per default.
describe port(443) do
  it { should be_listening }
  its('processes') { should include 'nginx' }
end

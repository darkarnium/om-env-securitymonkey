# Ensure Supervisor is running and will start at boot.
describe service('supervisor') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Ensure Security Monkey is listening.
describe port(5000) do
  it { should be_listening }
  its('processes') { should include 'python' }
  its('addresses') { should include '127.0.0.1' }
end

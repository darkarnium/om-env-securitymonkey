# Ensure PostgreSQL is running and will start at boot.
describe service('postgresql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Ensure PostgreSQL is listening.
describe port(5432) do
  it { should be_listening }
  its('processes') { should include 'postgres' }
  its('addresses') { should include '127.0.0.1' }
end

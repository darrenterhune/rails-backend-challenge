# Seed data is intentionally left blank.
# Candidates can add sample clients/providers/availabilities once their schema is in place.
Client.create(name: 'John Doe', email: 'johndoe@example.com')
Client.create(name: 'Jack Smith', email: 'jacksmith@example.com')

Provider.create(name: 'Great Provider Inc.', email: 'greatprovider@example.com')
Provider.create(name: 'Other Provider LLC.', email: 'otherprovider@example.com')
Provider.create(name: 'Default Provider LLC.', email: 'defaultprovider@example.com')

Provider.find_each do |provider|
  AvailabilitySync.new.call(provider_id: provider.id)
end

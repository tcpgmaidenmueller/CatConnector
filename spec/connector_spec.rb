RSpec.describe 'connector', :vcr do
  let( :connector ) { Workato::Connector::Sdk::Connector.from_file( 'connector.rb', settings ) }
  let( :settings ) { Workato::Connector::Sdk::Settings.from_default_file }

  it {
    expect( connector ).to be_present
  }

  describe 'test' do
    it {
      # Function Call
      output = connector.test( settings )

      # Assertion
      expect( output ).to eq( 200 )
    }
  end
end

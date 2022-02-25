RSpec.describe 'actions/search_random_pictures', :vcr do
  let( :connector ) { Workato::Connector::Sdk::Connector.from_file( 'connector.rb', settings ) }
  let( :settings ) { Workato::Connector::Sdk::Settings.from_default_file }

  let( :action ) { connector.actions.search_random_pictures }

  describe 'execute' do
    let( :input ) { JSON.parse( File.read( 'fixtures/actions/search_random_pictures/input.json' ) ) }
    let( :expected_pictures ) { JSON.parse( File.read( 'fixtures/actions/search_random_pictures/output.json' ) ) }

    it 'returns cat pictures' do
      # Function Call
      output = action.execute( settings, input )

      # Assertion
      expect( output ).to eq( expected_pictures )
    end
  end
end

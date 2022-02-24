RSpec.describe 'actions/list_breeds', :vcr do 
  let( :connector ) { Workato::Connector::Sdk::Connector.from_file( 'connector.rb', settings ) }
  let( :settings ) { Workato::Connector::Sdk::Settings.from_default_file }

  let( :action ) { connector.actions.list_breeds }

  describe 'execute' do
    let( :expected_cat_breeds ) { JSON.parse( File.read( 'fixtures/actions/list_breeds/output.json' ) ) }

    it 'returns abridged list of cat breeds' do
      # Function Call
      output = action.execute( settings )

      # Assertion
      expect( output ).to eq( expected_cat_breeds )
    end
  end
end

{
  title: 'Cat Connector',

  connection: {
    authorization: {
      type: 'custom_auth'
    },

    base_uri: lambda do |_connection|
      'https://api.thecatapi.com/v1/'
    end
  },

  test: lambda do |_connection|
    200
  end,

  actions: {
    list_breeds: {
      title: 'List All Cat Breeds',
      subtitle: 'Returns all cat breeds from thecatapi',
      execute: lambda do |_connection, _input|
        response = get('breeds')
        breeds = []
        response.each do |breed|
          breeds.push(
            {
              name: breed['name'],
              origin: breed['origin']
            }
          )
        end

        { data: breeds }
      end,
      output_fields: lambda do |object_definition|
        object_definition['cat_breed']
      end
    }
  },

  triggers: {

  },

  methods: {

  },

  object_definitions: {
    cat_breed: {
      fields: lambda do
        [
          {
            name: 'data',
            label: 'List of cat breeds',
            type: 'array',
            of: 'object',
            properties: [
              {
                name: 'name',
                label: 'Cat breed name',
                type: 'string'
              },
              {
                name: 'origin',
                label: 'Origin of the cat breed',
                type: 'string'
              }
            ]
          }
        ]
      end
    }
  },

  pick_lists: {

  }
}

{
  title: 'Cat Connector',

  connection: {
    authorization: {
      type: 'custom_auth'
    },

    base_uri: lambda do | _connection |
      'https://api.thecatapi.com/v1/'
    end
  },

  test: lambda do |_connection|
    200
  end,

  actions: {
    list_breeds: {
      title: 'List the Cat Breeds',
      subtitle: 'Returns all cat breeds from thecatapi',
      execute: lambda do | _connection, _input |
        response = get( 'breeds' )
        breeds = []
        response.each do | breed |
          breeds.push(
            {
              name: breed['name'],
              origin: breed['origin']
            }
          )
        end

        { data: breeds }
      end,
      output_fields: lambda do | object_definition |
        object_definition['cat_breed']
      end
    },
    search_random_pictures: {
      title: 'Search Random Cat Pictures',
      subtitle: 'Finds 1 or more random pictures of a specific breed',
      input_fields: lambda do
        [
          {
            name: 'breed_id',
            label: 'Cat breed ID',
            type: 'string',
            control_type: 'select',
            optional: false,
            sticky: true,
            toggle_hint: 'Select from list',
            pick_list: 'breeds',
          }
        ]
      end,
      execute: lambda do | _connection, input |
        response = get( 'images/search' ).params( {
          limit: 10,
          breed_id: input['breed_id'],
          order: 'DESC'
        } )

        images = []
        response.each do | image |
          images.push(
            {
              id: image['id'],
              url: image['url'],
              width: image['width'],
              height: image['height']
            }
          )
        end

        { pictures: images }
      end,
      output_fields: lambda do | object_definition |
        object_definition['cat_picture']
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
                name: 'id',
                label: 'Cat breed ID',
                type: 'string'
              },
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
    },
    cat_picture: {
      fields: lambda do
        [
          {
            name: 'pictures',
            label: 'List of 10 random cat pictures',
            type: 'array',
            of: 'object',
            properties: [
              {
                name: 'id',
                label: 'Picture ID',
                type: 'string'
              },
              {
                name: 'url',
                label: 'Image URL',
                type: 'string'
              },
              {
                name: 'width',
                label: 'Image width',
                type: 'number'
              },
              {
                name: 'height',
                label: 'Image height',
                type: 'number'
              }
            ]
          }
        ]
      end
    }
  },

  pick_lists: {
    breeds: lambda do | _connection |
      get( 'breeds' ).pluck( 'name', 'id' )
    end
  }
}

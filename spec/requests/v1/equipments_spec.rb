# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'v1/equipments', type: :request do
  path '/v1/equipments' do
    get('list equipment') do
      parameter name: 'category', in: :query, enum: {
        sewing: 'sewing',
        knitting: 'knitting',
        crochet: 'crochet',
        tatting: 'tatting',
        lace: 'lace',
        embroidery: 'embroidery',
        cross_stitch: 'cross_stitch',
        weaving: 'weaving',
        macrame: 'macrame',
        spinning: 'spinning',
        felting: 'felting'
      }

      parameter name: 'page', in: :query, type: :integer
      parameter name: 'sort', in: :query, type: :string
      parameter name: 'search', in: :query, type: :string

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/v1/equipments/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show equipment') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end

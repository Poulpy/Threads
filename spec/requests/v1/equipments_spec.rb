# frozen_string_literal: true

require 'swagger_helper'

RSpec.shared_context 'with response example' do
  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }
  end
end

RSpec.describe 'v1/equipments', type: :request do
  fixtures :users, :equipments

  let(:Authorization) { "Bearer #{users(:paul).auth_token}" }

  path '/v1/equipments' do
    get('list equipment') do
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string, required: true
      parameter name: 'category', in: :query, required: false,
                schema: { type: :string, enum: Equipment.categories.keys }
      parameter name: 'page', in: :query, required: false, schema: { type: :integer }
      parameter name: 'sort', in: :query, required: false,
                schema: { type: :string, enum: %w[asc desc] }
      parameter name: 'search', in: :query, required: false, schema: { type: :string }

      response(200, 'successful') do
        include_context 'with response example'

        run_test!
      end

      response(200, 'filtered by category') do
        let(:category) { 'sewing' }

        run_test! do
          json = response.parsed_body
          expect(json).to all(include('category' => 'sewing'))
        end
      end

      response(422, 'unknown category') do
        let(:category) { 'invalid_category' }

        run_test!
      end

      response(422, 'invalid page') do
        let(:page) { 0 }

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }

        run_test!
      end
    end
  end

  path '/v1/equipments/{id}' do
    parameter name: 'Authorization', in: :header, type: :string, required: true
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show equipment') do
      produces 'application/json'

      response(200, 'successful') do
        include_context 'with response example'

        let(:id) { equipments(:sewing_machine).id }

        run_test!
      end

      response(404, 'equipment not found') do
        let(:id) { 0 }

        run_test!
      end
    end
  end
end

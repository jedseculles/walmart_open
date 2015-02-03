require "walmart_open/request"
require "walmart_open/item"
require "walmart_open/errors"

module WalmartOpen
  module Requests
    class Lookup < Request
      def initialize(item_id, params = {})
        self.path = 'items' + (item_id.to_s.empty? ? '' : "/#{item_id}")
        # accepts multiple ids, comma-separated string
        # {ids: "12345678,23456789,34567890"}
        self.params = params
      end

      private

      def parse_response(response)
        if response.parsed_response.has_key?('items')
          response.parsed_response['items'].map {|item| Item.new(item)}
        else
          Item.new(response.parsed_response)
        end
      end

      def verify_response(response)
        if response.code == 400
          raise WalmartOpen::ItemNotFoundError, response.parsed_response.inspect
        end
        super
      end
    end
  end
end

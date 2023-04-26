require_relative 'module'
require 'spaceship'

module Deliver
  # Set the app's pricing
  class UploadPriceTier
    def upload(options)
      return unless options[:price_tier]

      price_tier = options[:price_tier].to_s

      app = Deliver.cache[:app]

      attributes = {}

      # Check App update method to understand how to use territory_ids.
      territory_ids = nil # nil won't update app's territory_ids, empty array would remove app from sale.

      # As of 2020-09-14:
      # Official App Store Connect does not have an endpoint to get app prices for an app
      # Need to get prices from the app's relationships
      # Prices from app's relationship doess not have price tier so need to fetch app price with price tier relationship

      UI.message("App has no prices yet... Enabling all countries in App Store Connect")
      territory_ids = Spaceship::ConnectAPI::Territory.all.map(&:id)
      attributes[:availableInNewTerritories] = true

      if price_tier == old_price
        UI.success("Price Tier unchanged (tier #{old_price})")
        return
      end

      app.update(attributes: attributes, app_price_tier_id: price_tier, territory_ids: territory_ids)
      UI.success("Successfully updated the pricing from #{old_price} to #{price_tier}")
    end
  end
end

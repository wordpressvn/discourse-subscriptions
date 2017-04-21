require 'rails_helper'
require_relative '../../support/dd_helper'

module DiscourseDonations
  RSpec.describe ChargesController, type: :controller do
    routes { DiscourseDonations::Engine.routes }

    before do
      SiteSetting.stubs(:discourse_donations_secret_key).returns('secret-key-yo')
      SiteSetting.stubs(:discourse_donations_description).returns('charity begins at discourse plugin')
      SiteSetting.stubs(:discourse_donations_currency).returns('AUD')
    end

    it 'responds ok for anonymous users' do
      post :create, { email: 'foobar@example.com' }
      expect(response).to have_http_status(200)
    end

    it 'responds ok when the email is empty' do
      post :create, { email: '' }
      expect(response).to have_http_status(200)
    end

    it 'responds ok for logged in user' do
      current_user = log_in(:coding_horror)
      post :create
      expect(response).to have_http_status(200)
    end

    it 'has no rewards' do
      current_user = log_in(:coding_horror)
      post :create
      expect(JSON.parse(response.body)['rewards']).to eq([])
    end
  end
end

require 'rails_helper'

RSpec.describe 'Session', type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @sign_in_url = '/auth/sign_in'
    @substring_calculations_url = "/users/#{@user.id}/substring_calculations"
    @login_params = {
      email: @user.email,
      password: @user.password,
    }
  end

  describe 'GET /users/:user_id/substring_calculations' do
    before do
      post @sign_in_url, params: @login_params, as: :json
      @headers = {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token'],
      }
      @user.substring_calculations.create(
        main_string: 'abcdef',
        sub_string: 'abc'
      )
      @user.substring_calculations.create(
        main_string: 'defgho',
        sub_string: 'dhj'
      )
    end

    it 'returns status 200' do
      get @substring_calculations_url, headers: @headers
      expect(response).to have_http_status(200)
    end

    it 'returns JSON of all substring calculations' do
      get @substring_calculations_url, headers: @headers
      json_res = JSON.parse(response.body)['calculations']
      expect(json_res.first['main_string']).to eq('abcdef')
      expect(json_res.first['sub_string']).to eq('abc')
      expect(json_res.first['result']).to be(true)
      expect(json_res.last['main_string']).to eq('defgho')
      expect(json_res.last['sub_string']).to eq('dhj')
      expect(json_res.last['result']).to be(false)
    end
  end

  describe 'POST /users/:user_id/substring_calculations' do
    before do
      post @sign_in_url, params: @login_params, as: :json
      @headers = {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token'],
      }
      @params = {
        substring_calculations: {
          main_string: 'abcdef',
          sub_string: 'abc'
        }
      }
    end

    it 'returns status 201' do
      post @substring_calculations_url, headers: @headers, params: @params
      expect(response).to have_http_status(201)
    end

    it 'returns JSON of new substring calculation' do
      post @substring_calculations_url, headers: @headers, params: @params
      json_res = JSON.parse(response.body)
      expect(json_res['main_string']).to eq('abcdef')
      expect(json_res['sub_string']).to eq('abc')
      expect(json_res['result']).to be(true)
    end

    it 'creates new substring calculation' do
      previous_count = @user.substring_calculations.count
      post @substring_calculations_url, headers: @headers, params: @params
      new_count = @user.reload.substring_calculations.count
      expect(new_count).to eq(previous_count + 1)
    end
  end

  describe 'DELETE /users/:user_id/substring_calculations/:substring_id' do
    before do
      post @sign_in_url, params: @login_params, as: :json
      @headers = {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token'],
      }

      @substring_cal = @user.substring_calculations.create(
        main_string: 'abcdef',
        sub_string: 'abc'
      )
    end

    it 'returns status 201' do
      delete @substring_calculations_url + "/#{@substring_cal.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it 'deletes substring calculation' do
      previous_count = @user.substring_calculations.count
      delete @substring_calculations_url + "/#{@substring_cal.id}", headers: @headers
      new_count = @user.reload.substring_calculations.count
      expect(new_count).to eq(previous_count - 1)
    end
  end
end
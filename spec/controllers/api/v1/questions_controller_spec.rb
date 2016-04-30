require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  # rspec by default does not render views when testing the controller.
  render_views
  describe "Fetching a List of Questions" do

      context "with valid api_key" do
        let!(:user){ FactoryGirl.create(:user) }
        let!(:question) { FactoryGirl.create(:question) }

        it "includes the question's title" do
          get :index, api_key: user.api_key, format: :json
          expect(response.body). to match(/#{question.title}/i)
        end

        it "includes the question's body" do
          get :index, api_key: user.api_key, format: :json
          parsed_json = JSON.parse(response.body)
          # syntax for using serializer
          expect(parsed_json["questions"][0]["body"]).to eq(question.body)
          # syntax below for jbuilder
          # expect(parsed_json[0]["body"]).to eq(question.body)
        end

      end

      context "with invalid api_key" do
        it "returns a 401 HTTP response code" do
          # have to be explicit to render json
          get :index, format: :json
          expect(response.code).to eq("401")
        end
      end


  end
end

# two primary scenarios, valid, invalid

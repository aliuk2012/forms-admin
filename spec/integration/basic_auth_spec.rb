require "rails_helper"

RSpec.describe "using basic auth" do
  let(:username) { "tester" }
  let(:password) { "password" }

  let(:basic_auth_settings) do
    Config::Options.new(
      organisation: Config::Options.new(
        slug: "test-org",
        name: "Test Org",
        content_id: "",
      ),
      enabled: true,
      username:,
      password:,
    )
  end

  before do
    api_headers = {
      "X-API-Token" => Settings.forms_api.auth_key,
      "Accept" => "application/json",
    }

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/api/v1/forms?org=test-org", api_headers, [].to_json, 200
    end

    allow(Settings).to receive(:basic_auth).and_return(basic_auth_settings)
  end

  it "app requests HTTP Basic Authentication when no user is logged in" do
    logout

    get root_path

    expect(response).to have_http_status(:unauthorized)
    expect(response.headers["WWW-Authenticate"]).to eq 'Basic realm="Application"'
  end

  describe "authentication" do
    before do
      allow(Settings).to receive(:basic_auth).and_return(basic_auth_settings)

      auth = ActionController::HttpAuthentication::Basic
        .encode_credentials(username, password)

      get root_path, headers: { "HTTP_AUTHORIZATION": auth }
    end

    it "signs in user as defined in settings" do
      expect(assigns[:current_user].name).to eq username
      expect(assigns[:current_user].email).to eq "#{username}@example.com"
      expect(assigns[:current_user].organisation.slug).to eq "test-org"
    end
  end
end

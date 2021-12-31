# frozen_string_literal: true

describe Auth::Token do
  context "when instantiating a token without an issuer" do
    it "raises an Auth::TokenErrors::InstantiatedWithoutIssuer Error" do
      expect {
        described_class.new token_payload(:missing_issuer_token)
      }.to raise_error(instance_of(Auth::Errors::TokenHasNoIssuer))
    end
  end

  context "when instantiating a token without a subject" do
    it "raises an Auth::TokenErrors::InstantiatedWithoutSubject Error" do
      expect {
        described_class.new token_payload(:missing_sub_token)
      }.to raise_error(instance_of(Auth::Errors::TokenHasNoSubject))
    end
  end

  context "when instantiating a token without an issued at time" do
    it "raises an Auth::Errors::TokenHasNoIssuedAt Error" do
      expect {
        described_class.new token_payload(:missing_issued_at_token)
      }.to raise_error(instance_of(Auth::Errors::TokenHasNoIssuedAt))
    end
  end

  context "given a valid Token" do
    it "will generate a valid jwt token" do
      token = described_class.new token_payload :valid_token
      expect(token.encode(ENV["JWT_SECRET"])).to be_a_valid_jwt_token
    end
  end

  context "given a valid Token with supplemental data" do
    it "will generate a valid jwt token" do
      token = described_class.new token_payload :valid_token_with_sup
      expect(token.encode(ENV["JWT_SECRET"])).to be_a_valid_jwt_token
    end
  end

  context "given a valid Token without any scopes" do
    it "will return false for token.scopes?" do
      token = described_class.new token_payload :valid_token_missing_scopes
      expect(token.encode(ENV["JWT_SECRET"])).to be_a_valid_jwt_token
      expect(token).not_to be_scopes(%w[test])
      expect(token).not_to be_scope("test")
    end
  end
end

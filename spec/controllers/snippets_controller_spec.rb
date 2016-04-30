require 'rails_helper'

RSpec.describe SnippetsController, type: :controller do

  let(:category) { Category.create({kind: "Ruby"}) }

  let(:user) { User.create({first_name: "Evan", last_name: "Tay", email: "evan@gmail.com", password: "abc", password_confirmation: "abc" }) }
  before { request.session[:user_id] = user.id }

  describe "#create" do
    context "with valid attributes" do
      def valid_request
        post :create, snippet: { category_id: category.id, title: "My snippet", work: "def method; end", private: false, user_id: user.id }
      end
      it "saves a record to the database" do
        count_before = Snippet.count
        valid_request
        count_after = Snippet.count
        expect(count_after).to eq(count_before + 1)
      end

      it "redirects to the snippet's show page" do
        valid_request
        expect(response).to redirect_to(snippet_path(Snippet.last))
      end

      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end

    end

    context "with invalid attributes" do
      def invalid_request
        post :create, snippet: { category_id: category.id, work: "def method; end", private: false, user_id: user.id }
      end
      it "doesn't save a record to the database" do
        count_before = Snippet.count
        invalid_request
        count_after = Snippet.count
        expect(count_after).to eq(count_before)
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets an alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#update" do

    let(:snippet) { Snippet.create({category_id: category.id, title: "My snippet", work: "def method; end", private: false, user_id: user.id}) }

    context "with valid params" do
      before do
        patch :update, id: snippet.id, snippet: {title: "My snippet 2"}
      end

      it "updates the record whose id is passed" do
        expect(snippet.reload.title).to eq("My snippet 2")
      end

      it "redirects to the show page" do
        expect(response).to redirect_to(snippet_path(snippet))
      end

      it "sets a flash notice message" do
        expect(flash[:notice]).to be
      end

    end
    context "with invalid params" do
      before do
        patch :update, id: snippet, snippet: {title: ""}
      end
      it "doesnt update the record whose id is passed" do
        expect(snippet.reload.title).to eq(snippet.title)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "sets an alert message" do
        expect(flash[:alert]).to be
      end
    end
  end

end

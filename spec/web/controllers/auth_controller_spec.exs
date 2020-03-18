defmodule Squadster.Web.AuthControllerSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  describe "vk.com OAuth" do
    describe "GET /api/auth/vk" do
      it "redirects to vk.com" do

      end
    end

    describe "GET /api/auth/vk/callback" do
      context "when auth is successful" do
        context "and user with provided token already exists" do
          it "finds user and redirects to front-end with user info" do

          end
        end

        context "and it's new user" do
          it "creates user" do

          end

          it "redirects to front-end with user info" do

          end
        end

      end

      context "when auth failure accured" do
        it "redirects to front-end with error" do

        end
      end
    end
  end

  describe "DELETE /api/auth" do
    it "sets current_user token to nil" do

    end

    it "responds with status message" do

    end
  end
end
